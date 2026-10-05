//
//  Created by Kurlovich Vitali on 10/4/26.
//

import SwiftUI

struct SymbolFeedPricesListView: View {
    let symbols: [Symbol]

    #if os(macOS)
        let isCompact = false
    #else

        @Environment(\.horizontalSizeClass)
        private var horizontalSizeClass

        var isCompact: Bool {
            horizontalSizeClass == .compact
        }
    #endif

    @Binding
    var selectedItems: Set<Symbol.ID>

    var body: some View {
        Table(symbols, selection: $selectedItems) {
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
        }
    }
}
