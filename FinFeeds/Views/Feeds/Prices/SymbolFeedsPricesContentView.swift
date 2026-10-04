//
//  Created by Kurlovich Vitali on 10/4/26.
//

import Foundation
import SwiftData
import SwiftUI

struct SymbolFeedsPricesContentView: View {
    @Environment(\.symbolPriceService)
    private var service

    @Environment(\.modelContext)
    private var modelContext

    @Query(filter: #Predicate<FeedsSubscriptions> {
        $0.name == "feeds"
    }) private var dataModel: [FeedsSubscriptions]

    @Binding
    private var subscriptions: Set<String>

    @State
    private var selectedItems = Set<Symbol.ID>()

    init(
        _ subscriptions: Binding<Set<String>>

    ) {
        _subscriptions = subscriptions
    }

    var body: some View {
        SymbolFeedPricesListView(symbols: orderedSubscriptions, selectedItems: $selectedItems)
            .contextMenu {
                Button(role: .destructive) {
                    removeSelected()
                } label: {
                    Label("Remove", systemImage: "trash")
                }.disabled(selectedItems.isEmpty)
                SymbolMenu(disabled: subscriptions) { symbol in
                    _ = withAnimation {
                        subscriptions.insert(symbol)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    SymbolMenu(disabled: subscriptions) { symbol in
                        _ = withAnimation {
                            subscriptions.insert(symbol)
                        }
                    }
                }
            }
        #if os(macOS)
            .onDeleteCommand {
                removeSelected()
            }
        #endif
    }

    var orderedSubscriptions: [Symbol] {
        subscriptions.sorted().map { Symbol($0) }
    }

    func removeSelected() {
        withAnimation {
            let remove = subscriptions.filter { selectedItems.contains($0) }
            subscriptions = subscriptions.subtracting(remove)
        }
    }
}

struct SymbolFeedsPricesSearchContentView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.forexService)
    var forexService

    @Environment(\.swiftDataForexPairsSyncCoordinator)
    var coordinator

    @Query
    private var dataModel: [ForexPairsStorage]

    @Binding
    private var subscriptions: Set<String>

    @State
    private var selectedItems = Set<Symbol.ID>()

    @Binding
    private var searchText: String

    private var searchPredicate: Predicate<ForexPairModel> {
        let uppercased = searchText.uppercased()
        return #Predicate<ForexPairModel> {
            $0.symbol.starts(with: uppercased)
        }
    }

    init(
        _ subscriptions: Binding<Set<String>>,
        searchText: Binding<String>
    ) {
        _subscriptions = subscriptions
        _searchText = searchText
    }

    var body: some View {
        SymbolFeedPricesListView(symbols: orderedSubscriptions, selectedItems: $selectedItems)
            .task {
                do {
                    try await coordinator
                        .sync(context: modelContext, service: forexService)
                } catch {
                    // TODO: Logging errors
                }
            }
    }

    var orderedSubscriptions: [Symbol] {
        if searchText.isEmpty {
            return dataModel.first?.pairs
                .sorted(by: \.symbol)
                .map {
                    Symbol($0.symbol)
                } ?? []
        }

        do {
            return try dataModel.first?.pairs
                .filter(searchPredicate)
                .sorted(by: \.symbol)
                .map {
                    Symbol($0.symbol)
                } ?? []

        } catch {
            // TODO: Logging error
            return []
        }
    }
}
