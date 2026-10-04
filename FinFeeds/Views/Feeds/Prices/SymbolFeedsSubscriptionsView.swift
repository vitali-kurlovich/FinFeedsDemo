//
//  Created by Kurlovich Vitali on 10/1/26.
//

import Foundation
import SwiftData
import SwiftUI

struct SymbolFeedsPricesView: View {
    @Environment(\.symbolPriceService)
    private var service

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    #if os(macOS)
        let isCompact = false
    #else
        var isCompact: Bool {
            horizontalSizeClass == .compact
        }
    #endif

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
        Table(orderedSubscriptions, selection: $selectedItems) {
            TableColumn("Symbol") { symbol in
                SymbolFeedsRow(symbol: symbol)
            }
            .width(min: 44, max: 88)
            TableColumn("Price") { symbol in
                SymbolFeedsPriceRow(symbol: symbol)
            }
            if isCompact == false {
                TableColumn("Last Update") { symbol in
                    SymbolFeedsTimestampRow(symbol: symbol)
                }
            }
        }.contextMenu {
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

struct SymbolFeedsSubscriptionsView<Content: View>: View {
    @Environment(\.modelContext)
    private var modelContext

    @Query(filter: #Predicate<FeedsSubscriptions> {
        $0.name == "feeds"
    }) private var dataModel: [FeedsSubscriptions]

    private let content: (Binding<Set<String>>) -> Content

    @State
    private var searchText: String = ""

    init(
        content: @escaping (Binding<Set<String>>) -> Content
    ) {
        self.content = content
    }

    var body: some View {
        content(.init(get: {
            dataModel.first?.subscriptions ?? []
        }, set: { subscriptions in
            if let feeds = dataModel.first {
                feeds.subscriptions = subscriptions

            } else {
                let feeds = FeedsSubscriptions(name: "feeds", subscriptions: subscriptions)
                modelContext.insert(feeds)
            }
        }))
        .searchable(text: $searchText)
    }
}
