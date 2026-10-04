//
//  Created by Kurlovich Vitali on 10/3/26.
//

import SwiftData
import SwiftUI

struct SymbolFeedsRow: View {
    let symbol: Symbol

    @Environment(\.symbolPriceService)
    private var service

    @Environment(\.modelContext)
    private var modelContext

    @Query
    private var feed: [Feed]

    init(symbol: Symbol) {
        self.symbol = symbol

        let name = symbol.id

        let predicate = #Predicate<Feed> { feed in
            feed.symbol == name
        }

        _feed = Query(
            filter: predicate, animation: .default
        )
    }

    var body: some View {
        Text(text)
            .foregroundStyle(fill)
            .contentTransition(.interpolate)
            .onAppear {
                service.subsribe([symbol.id])
            }
            .onDisappear {
                service.unsubsribe([symbol.id])
            }
    }
}

private extension SymbolFeedsRow {
    var text: String {
        symbol.description
    }

    var price: Decimal? {
        feed.first?.price?.price
    }

    var isPriceExists: Bool {
        price != nil
    }

    var fill: some ShapeStyle {
        isPriceExists ? Color.primary.gradient : Color.secondary.gradient
    }
}
