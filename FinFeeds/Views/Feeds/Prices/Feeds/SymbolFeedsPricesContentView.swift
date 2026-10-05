//
//  Created by Kurlovich Vitali on 10/4/26.
//

import Foundation
import SwiftData
import SwiftUI

struct SymbolFeedsPricesContentView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Binding
    private var subscriptions: Set<String>

    @State
    private var selectedItems = Set<FeedsUpdate.ID>()

    @State
    var feedsUpdates = SwiftDataFeedsObserver()

    init(
        _ subscriptions: Binding<Set<String>>

    ) {
        _subscriptions = subscriptions
    }

    var body: some View {
        SymbolFeedPricesListView(
            updates: feedsUpdates.updates,
            selectedItems: $selectedItems
        )
        .contextMenu {
            Button(role: .destructive) {
                removeSelected()
            } label: {
                Label("Remove", systemImage: "trash")
            }.disabled(selectedItems.isEmpty)
        }
        .onChange(of: subscriptions) {
            feedsUpdates.subscribed = subscriptions
        }
        .onAppear {
            do {
                try feedsUpdates.start(context: modelContext, subscribed: subscriptions)
            } catch {
                // TODO: Logging error
            }
        }.onDisappear {
            feedsUpdates.stop()
        }
        #if os(macOS)
        .onDeleteCommand {
            removeSelected()
        }
        #endif
    }

    func removeSelected() {
        withAnimation {
            let removedSymbols = selectedItems.map { $0.id }
            subscriptions = subscriptions.subtracting(removedSymbols)
        }
    }
}
