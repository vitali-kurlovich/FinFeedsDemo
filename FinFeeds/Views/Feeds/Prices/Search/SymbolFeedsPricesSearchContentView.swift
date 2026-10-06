//
//  Created by Kurlovich Vitali on 10/4/26.
//

import DataLayer
import SwiftData
import SwiftUI

struct SymbolFeedsPricesSearchContentView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.forexService)
    private var forexService

    @Environment(\.cryptoService)
    private var cryptoService

    @Environment(\.stockService)
    private var stockService

    @Environment(\.commoditiesService)
    private var commoditiesService

    @Environment(\.swiftDataSync)
    private var swiftDataSync

    @Query
    private var dataModel: [SymbolsStorage]

    private var storage: SymbolsStorage? {
        dataModel.filter { $0.type == symbolType }.first
    }

    @Binding
    private var subscriptions: Set<String>

    @State
    private var selectedItems = Set<FeedsUpdate.ID>()

    @Binding
    private var searchText: String

    @State
    private var symbolType: SymbolType = .forex

    @State
    var feedsUpdates = SwiftDataFeedsObserver()

    init(
        _ subscriptions: Binding<Set<String>>,
        searchText: Binding<String>
    ) {
        _subscriptions = subscriptions
        _searchText = searchText
    }

    var body: some View {
        SymbolFeedPricesListView(
            updates: feedsUpdates.updates,
            selectedItems: $selectedItems
        )
        .contextMenu {
            Button {
                addSelected()
            } label: {
                Label("Add Selected", systemImage: "bag.badge.plus")
            }.disabled(selectedItems.isEmpty)
        }
        .onChange(of: searchText) {
            feedsUpdates.subscribed = filteredSubscriptions
        }
        .onChange(of: storage) {
            feedsUpdates.subscribed = filteredSubscriptions
        }
        .onChange(of: symbolType) {
            feedsUpdates.subscribed = filteredSubscriptions

            Task {
                do {
                    try await syncCoreData(type: symbolType)
                } catch {
                    // TODO: Logging errors
                    print(error)
                }
            }
        }
        .onAppear {
            do {
                try feedsUpdates
                    .start(
                        context: modelContext,
                        subscribed: filteredSubscriptions
                    )
            } catch {
                // TODO: Logging error
            }
        }.onDisappear {
            feedsUpdates.stop()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                SymbolTypePicker(type: $symbolType)
            }
        }
        .task {
            do {
                try await syncCoreData(type: symbolType)
            } catch {
                // TODO: Logging errors
            }
        }
    }
}

private extension SymbolFeedsPricesSearchContentView {
    func addSelected() {
        withAnimation {
            let selected = selectedItems.map { $0.id }
            subscriptions = subscriptions.union(selected)
            selectedItems = []
        }
    }

    func syncCoreData(type: SymbolType) async throws {
        do {
            switch type {
            case .forex:
                try await swiftDataSync.sync(context: modelContext, with: forexService)

            case .crypto:
                try await swiftDataSync
                    .sync(context: modelContext, with: cryptoService)

            case .commodities:
                try await swiftDataSync
                    .sync(context: modelContext, with: commoditiesService)

            case .stock:
                try await swiftDataSync
                    .sync(context: modelContext, with: stockService)
            }
        } catch {
            // TODO: Logging errors

            print(error)
        }
    }
}

private extension SymbolFeedsPricesSearchContentView {
    var filteredSubscriptions: Set<String> {
        guard let storage else {
            return []
        }
        let symbols = storage.symbols

        return filterd(symbols: symbols)
    }

    func filterd(symbols: Set<String>) -> Set<String> {
        if searchText.isEmpty {
            return symbols
        }
        return symbols.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
}

struct SymbolTypePicker: View {
    @Binding
    var type: SymbolType

    var body: some View {
        Picker("Type", selection: $type) {
            ForEach(
                SymbolType.allCases,
                id: \.self
            ) { selected in
                Text("\(selected.rawValue)")
            }
        }.pickerStyle(.segmented)
    }
}
