//
//  Created by Kurlovich Vitali on 10/1/26.
//

import SwiftUI

struct SymbolPriceFeedsUpdaterView<Content: View>: View {
    @Environment(\.symbolPriceFeedsService)
    private var service

    @State
    private var feeds: [SymbolPriceFeed] = []

    @Binding
    private var subscriptions: Set<String>

    private let content: ([SymbolPriceFeed]) -> Content

    init(
        subscriptions: Binding<Set<String>>,
        content: @escaping ([SymbolPriceFeed]) -> Content
    ) {
        _subscriptions = subscriptions
        self.content = content
    }

    var body: some View {
        SymbolPriceFeedsView(feeds: $feeds, content: content)
            .onAppear {
                service.subsribe(subscriptions)
            }
            .onDisappear {
                service.unsubsribe(subscriptions)
            }
            .onChange(of: subscriptions) { old, new in
                let subscribe = new.subtracting(old)
                let unsubscribe = old.subtracting(new)

                service.subsribe(subscribe)
                service.unsubsribe(unsubscribe)
            }
            .task(name: "Feeds stream") {
                Task {
                    for await feeds in service.feeds {
                        onRecieve(feeds: feeds)
                    }
                }
            }
    }
}

private extension SymbolPriceFeedsUpdaterView {
    func onRecieve(feeds: [SymbolPriceFeed]) {
        let newFeeds = feeds.filter {
            subscriptions.contains($0.symbol)
        }.sorted(by: \.symbol)

        if self.feeds != newFeeds {
            self.feeds = newFeeds
        }
    }
}
