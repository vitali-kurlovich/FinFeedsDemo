//
//  Created by Kurlovich Vitali on 10/4/26.
//

import SwiftData
import SwiftUI

struct SymbolFeedsPricesSearchContentView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.forexService)
    var forexService

    @Query
    private var dataModel: [SymbolsStorage]

    private var storage: SymbolsStorage? {
        dataModel.filter { $0.type == symbolType }.first
    }

    @Binding
    private var subscriptions: Set<String>

    @State
    private var selectedItems = Set<Symbol.ID>()

    @Binding
    private var searchText: String

    @Binding
    private var isPresented: Bool

    @State
    private var isSync: Bool = false

    @State
    private var symbolType: SymbolType = .forex

    private var storagePredicate: Predicate<SymbolsStorage> {
        // let uppercased = searchText.uppercased()

        let typeRaw = symbolType.rawValue
        return #Predicate<SymbolsStorage> {
            $0.typeRaw == typeRaw
            // $0.symbol.starts(with: uppercased)
        }
    }

    init(
        _ subscriptions: Binding<Set<String>>,
        searchText: Binding<String>,
        isPresented: Binding<Bool>
    ) {
        _subscriptions = subscriptions
        _searchText = searchText
        _isPresented = isPresented
    }

    var body: some View {
        if isPresented {
            SymbolFeedPricesListView(symbols: orderedSubscriptions, selectedItems: $selectedItems)

                .contextMenu {
                    Button {
                        addSelected()
                    } label: {
                        Label("Add Selected", systemImage: "bag.badge.plus")
                    }.disabled(selectedItems.isEmpty)
                }

                .task {
                    guard isSync == false else { return }

                    do {
                        let coordinator = SwiftDataForexPairsSyncCoordinator()

                        try await coordinator
                            .sync(context: modelContext, service: forexService)
                        isSync = true
                    } catch {
                        // TODO: Logging errors
                    }
                }
        }
    }

    func addSelected() {
        withAnimation {
            subscriptions = subscriptions.union(selectedItems)
            selectedItems = []
            isPresented = false
        }
    }

    var orderedSubscriptions: [Symbol] {
        guard let storage else { return [] }

        if searchText.isEmpty {
            return storage.symbols
                .sorted()
                .map {
                    Symbol($0)
                }
        }

        return storage.symbols
            .filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }.sorted()
            .map {
                Symbol($0)
            }
    }
}
