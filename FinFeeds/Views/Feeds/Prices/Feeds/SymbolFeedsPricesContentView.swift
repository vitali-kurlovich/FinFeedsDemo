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
