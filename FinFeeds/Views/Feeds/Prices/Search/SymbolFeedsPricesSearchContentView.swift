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

    @Environment(\.feedSubscribtionsUpdater)
    private var feedSubscribtionsUpdater

    @Query
    private var dataModel: [SymbolsStorage]

    private var storage: SymbolsStorage? {
        dataModel.filter { $0.type == symbolType }.first
    }

    @State
    private var selectedItems = Set<Symbol.ID>()

    @Binding
    private var searchText: String

    @State
    private var symbolType: SymbolType = .forex

    init(
        searchText: Binding<String>
    ) {
        _searchText = searchText
    }

    var body: some View {
        SymbolFeedPricesListView(
            symbols: symbols,
            selectedItems: $selectedItems
        )
        .contextMenu {
            Button {
                addSelected()
            } label: {
                Label("Add Selected", systemImage: "bag.badge.plus")
            }.disabled(selectedItems.isEmpty)
        }
        .onChange(of: symbolType) {
            Task {
                do {
                    try await syncCoreData(type: symbolType)
                } catch {
                    // TODO: Logging errors
                    print(error)
                }
            }
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
    var symbols: [Symbol] {
        let symbols: Set<String>

        if searchText.isEmpty {
            symbols = storage?.symbols ?? []
        } else {
            symbols = storage?.symbols.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            } ?? []
        }

        return symbols.lazy.map {
            Symbol($0)
        }.sorted(by: \.id)
    }

    func addSelected() {
        Task {
            do {
                let subscriptions = storage?.symbols.filter { selectedItems.contains($0) } ?? []

                let insert = subscriptions.map { Symbol($0) }

                try await feedSubscribtionsUpdater.insert(subscriptions: Set(insert))

            } catch {}
            withAnimation {
                selectedItems = []
            }
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
