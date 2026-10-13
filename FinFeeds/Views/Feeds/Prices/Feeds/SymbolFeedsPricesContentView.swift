//
//  Created by Kurlovich Vitali on 10/4/26.
//

import DataLayer
import Foundation
import SwiftData
import SwiftUI

struct SymbolFeedsPricesContentView: View {
    @Environment(\.feedSubscribtionsUpdater)
    private var feedSubscribtionsUpdater

    @State
    private var selectedItems = Set<Symbol.ID>()

    var body: some View {
        SymbolFeedPricesListView(
            symbols: feedSubscribtionsUpdater.subscriptions,
            selectedItems: $selectedItems
        )
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

    func removeSelected() {
        Task {
            let subscriptions = feedSubscribtionsUpdater.subscriptions

            let remove = subscriptions.filter { selectedItems.contains($0.id) }
            do {
                try await feedSubscribtionsUpdater
                    .remove(subscriptions: Set(remove))
            } catch {
                // TODO: Logging error
            }
        }
    }
}
