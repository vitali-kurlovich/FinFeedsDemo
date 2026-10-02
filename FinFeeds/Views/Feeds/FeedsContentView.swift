//
//  Created by Kurlovich Vitali on 10/2/26.
//

import Caches
import SwiftUI

struct FeedsContentView: View {
    @Binding
    var subscriptions: Set<String>

    var body: some View {
        VStack {
            SymbolPriceFeedsUpdaterView(subscriptions: $subscriptions) { feeds in
                Table(feeds) {
                    TableColumn("Symbol") { feed in
                        Text(feed.symbol)
                            .foregroundStyle(color(for: feed))
                    }
                    .width(min: 44, max: 88)
                    TableColumn("Price") { feed in
                        PriceFeedView(feed: feed)
                            .foregroundStyle(color(for: feed))
                    }
                    TableColumn("Last Update") { feed in
                        Text(feed.timestamp?.formatted() ?? "-")
                            .foregroundStyle(color(for: feed))
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem {
                Button("Save Cache") {
                    Task {
                        do {
                            try await CachesLocator.pricesCache.save()
                        } catch {
                            // TODO: Error handeling
                        }
                    }
                }
            }
        }
    }
}

private extension FeedsContentView {
    func color(for feed: SymbolPriceFeed) -> Color {
        switch feed {
        case .none, .cached:
            return Color.secondary
        case .live:
            return .primary
        }
    }
}

private struct PriceFeedView: View {
    let feed: SymbolPriceFeed

    var body: some View {
        Text(text)
    }

    var text: String {
        switch feed {
        case .none:
            "-"
        case let .cached(item):
            item.price.formatted()
        case let .live(item):
            item.price.formatted()
        }
    }
}
