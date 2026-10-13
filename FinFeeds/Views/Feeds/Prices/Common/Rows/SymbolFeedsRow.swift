//
//  Created by Kurlovich Vitali on 10/3/26.
//

import DataLayer
import Foundation
import SwiftUI

struct SymbolFeedsRow: View {
    let symbol: Symbol

    @State
    private var update: CachableItem<FeedsUpdate> = .none

    @Environment(\.feedsUpdateWatcher)
    private var feedsUpdateWatcher

    init(symbol: Symbol) {
        self.symbol = symbol
    }

    var body: some View {
        Text(text)
            .foregroundStyle(fill)
            .contentTransition(.interpolate)
            .animation(.bouncy, value: update)
            .task {
                for await feed in feedsUpdateWatcher(symbol: symbol) {
                    self.update = feed
                }
            }
    }
}

private extension SymbolFeedsRow {
    var text: String {
        symbol.description
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

    var isPriceExists: Bool {
        price != nil
    }

    var fill: some ShapeStyle {
        isPriceExists ? Color.primary.gradient : Color.secondary.gradient
    }
}
