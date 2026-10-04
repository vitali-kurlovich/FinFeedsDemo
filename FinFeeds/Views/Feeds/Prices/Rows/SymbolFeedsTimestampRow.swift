//
//  Created by Kurlovich Vitali on 10/3/26.
//

import SwiftData
import SwiftUI

struct SymbolFeedsTimestampRow: View {
    let symbol: Symbol

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
    }
}

private extension SymbolFeedsTimestampRow {
    var text: String {
        timestamp?
            .formatted(.dateTime.month().day().hour().minute()) ?? "-"
    }

    var timestamp: Date? {
        feed.first?.price?.timestamp
    }

    var isDateExists: Bool {
        timestamp != nil
    }

    var fill: some ShapeStyle {
        isDateExists ? Color.primary.gradient : Color.secondary.gradient
    }
}
