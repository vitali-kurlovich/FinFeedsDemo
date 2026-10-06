//
//  Created by Kurlovich Vitali on 10/1/26.
//

import SwiftData
import SwiftUI

struct SymbolFeedsPricesView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Query
    private var subscriptionsStorage: [FeedsSubscriptions]

    @State
    private var searchText: String = ""

    @State
    private var isSearchPresented: Bool = false

    @FocusState
    private var searchFocused: Bool

    var subscriptionsBinding: Binding<Set<String>> {
        .init(get: {
            subscriptionsStorage.first?.subscriptions ?? []
        }, set: { subscriptions in
            if let feeds = subscriptionsStorage.first {
                feeds.subscriptions = subscriptions

            } else {
                let feeds = FeedsSubscriptions(subscriptions: subscriptions)
                modelContext.insert(feeds)
            }
        })
    }

    var body: some View {
        SymbolFeedsPricesContentView(subscriptionsBinding)
            .overlay {
                if isSearchPresented {
                    SymbolFeedsPricesSearchContentView(
                        subscriptionsBinding,
                        searchText: $searchText
                    )
                }
            }
            .searchable(text: $searchText, isPresented: $isSearchPresented)
            .searchFocused($searchFocused)
            .onChange(of: isSearchPresented) {
                searchFocused = isSearchPresented
                if isSearchPresented == false {
                    searchText = ""
                }
            }
    }
}
