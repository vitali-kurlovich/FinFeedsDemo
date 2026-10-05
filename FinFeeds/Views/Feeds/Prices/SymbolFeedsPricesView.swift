//
//  Created by Kurlovich Vitali on 10/1/26.
//

import SwiftData
import SwiftUI

struct SymbolFeedsPricesView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Query(filter: #Predicate<FeedsSubscriptions> {
        $0.name == "feeds"
    }) private var dataModel: [FeedsSubscriptions]

    @State
    private var searchText: String = ""

    @State
    private var isSearchPresented: Bool = false

    var subscriptionsBinding: Binding<Set<String>> {
        .init(get: {
            dataModel.first?.subscriptions ?? []
        }, set: { subscriptions in
            if let feeds = dataModel.first {
                feeds.subscriptions = subscriptions

            } else {
                let feeds = FeedsSubscriptions(name: "feeds", subscriptions: subscriptions)
                modelContext.insert(feeds)
            }
        })
    }

    var body: some View {
        SymbolFeedsPricesContentView(subscriptionsBinding)
            .overlay {
                SymbolFeedsPricesSearchContentView(
                    subscriptionsBinding,
                    searchText: $searchText,
                    isPresented: $isSearchPresented
                )
            }
            .searchable(text: $searchText, isPresented: $isSearchPresented)
    }
}
