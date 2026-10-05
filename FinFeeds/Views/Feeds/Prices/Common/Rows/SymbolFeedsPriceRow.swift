//
//  Created by Kurlovich Vitali on 10/3/26.
//

import Foundation
import SwiftData
import SwiftUI

struct SymbolFeedsPriceRow: View {
    private enum PriceChange {
        case neutral
        case up
        case down
    }

    @Environment(\.modelContext)
    private var modelContext

    @Query
    private var feed: [Feed]

    @State
    private var priceValue: Decimal?

    @State
    private var change: PriceChange = .neutral

    init(
        symbol: Symbol
    ) {
        let name = symbol.id

        let predicate = #Predicate<Feed> { feed in
            feed.symbol == name
        }

        _feed = Query(
            filter: predicate, animation: .bouncy
        )
    }

    var body: some View {
        HStack {
            Text(text)
                .contentTransition(transition)
            Spacer()
            Image(systemName: change == .up ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .contentTransition(.symbolEffect(.replace))
                .opacity(change == .neutral ? 0 : 1)
        }
        .foregroundStyle(fill)
        .onChange(of: price) {
            chagePrice(old: priceValue, new: price)
        }
    }
}

private extension SymbolFeedsPriceRow {
    var price: Decimal? {
        feed.first?.price?.price
    }

    var text: String {
        price?.formatted() ?? "-"
    }

    var fill: some ShapeStyle {
        switch change {
        case .neutral:
            Color.primary.gradient
        case .up:
            Color.green.gradient
        case .down:
            Color.red.gradient
        }
    }

    var transition: ContentTransition {
        if let priceValue {
            let value = NSDecimalNumber(decimal: priceValue).doubleValue
            return .numericText(value: value)
        } else {
            return .numericText()
        }
    }

    func chagePrice(old: Decimal?, new: Decimal?) {
        withAnimation {
            if let old, let new {
                if old < new {
                    change = .up
                } else if old > new {
                    change = .down
                } else {
                    change = .neutral
                }

            } else {
                change = .neutral
            }
        }

        priceValue = new
    }
}
