//
//  Created by Kurlovich Vitali on 10/3/26.
//

import DataLayer
import Foundation
import SwiftUI

struct SymbolFeedsPriceRow: View {
    let symbol: Symbol

    init(symbol: Symbol) {
        self.symbol = symbol
    }

    @State
    private var update: CachableItem<FeedsUpdate> = .none

    @Environment(\.feedsUpdateWatcher)
    private var feedsUpdateWatcher

    var body: some View {
        HStack {
            Text(text)
                .contentTransition(transition)
            Spacer()
            Image(systemName: changes == .up ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .contentTransition(.symbolEffect(.replace))
                .opacity((changes == .neutral || changes == .unknown) ? 0 : 1)
        }
        .foregroundStyle(fill)
        .animation(.bouncy, value: update)
        .task {

            for await feed in feedsUpdateWatcher(symbol: symbol) {
                self.update = feed
            }
        }
    }
}

private extension SymbolFeedsPriceRow {
    var text: String {
        price?.formatted() ?? "-"
    }

    var price: Decimal? {
        switch update {
        case .none:
            return nil
        case let .cached(feed):
            return feed.price
        case let .original(feed):
            return feed.price
        }
    }

    var changes: PriceChange {
        switch update {
        case .none:
            return .unknown
        case let .cached(feed):
            return feed.changes
        case let .original(feed):
            return feed.changes
        }
    }

    var fill: some ShapeStyle {
        switch changes {
        case .neutral:
            Color.primary.gradient
        case .up:
            Color.green.gradient
        case .down:
            Color.red.gradient
        case .unknown:
            Color.secondary.gradient
        }
    }

    var transition: ContentTransition {
        if let price {
            let value = NSDecimalNumber(decimal: price).doubleValue
            return .numericText(value: value)
        } else {
            return .numericText()
        }
    }
}
