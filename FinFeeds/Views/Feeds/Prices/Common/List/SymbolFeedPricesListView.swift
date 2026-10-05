//
//  Created by Kurlovich Vitali on 10/4/26.
//

import SwiftUI

struct SymbolFeedPricesListView: View {
    let updates: [FeedsUpdate]

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
    var selectedItems: Set<FeedsUpdate.ID>

    var body: some View {
        Table(updates, selection: $selectedItems) {
            TableColumn("Symbol") { update in
                SymbolFeedsRow(update)
            }
            .width(min: 44, max: 200)
            TableColumn("Price") { update in
                SymbolFeedsPriceRow(update)
            }
            if isCompact == false {
                TableColumn("Last Update") { update in
                    SymbolFeedsTimestampRow(update)
                }
            }
        }
    }
}
