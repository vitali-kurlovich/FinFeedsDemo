//
//  Created by Kurlovich Vitali on 10/3/26.
//

import Foundation
import SwiftData
import SwiftUI

struct SymbolFeedsPriceRow: View, Equatable {
    private let update: FeedsUpdate

    init(_ update: FeedsUpdate) {
        self.update = update
    }

    var body: some View {
        HStack {
            Text(text)
                .contentTransition(transition)
            Spacer()
            Image(systemName: changes == .up ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .contentTransition(.symbolEffect(.replace))
                .opacity(changes == .neutral ? 0 : 1)
        }
        .foregroundStyle(fill)
        .animation(.bouncy, value: update)
    }
}

private extension SymbolFeedsPriceRow {
    var text: String {
        price?.formatted() ?? "-"
    }

    var price: Decimal? {
        update.price
    }

    var changes: PriceChange {
        update.changes
    }

    var fill: some ShapeStyle {
        switch changes {
        case .neutral:
            Color.primary.gradient
        case .up:
            Color.green.gradient
        case .down:
            Color.red.gradient
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
