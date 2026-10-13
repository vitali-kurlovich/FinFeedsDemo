//
//  Created by Kurlovich Vitali on 10/3/26.
//

import DataLayer
import SwiftData
import SwiftUI

struct SymbolFeedsTimestampRow: View {
    let symbol: Symbol

    @Environment(\.feedsUpdateWatcher)
    private var feedsUpdateWatcher

    @State
    private var update: CachableItem<FeedsUpdate> = .none

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

private extension SymbolFeedsTimestampRow {
    var text: String {
        timestamp?
            .formatted(.dateTime.month().day().hour().minute()) ?? "-"
    }

    var timestamp: Date? {
        switch update {
        case .none:
            return nil
        case let .cached(feed):
            return feed.timestamp
        case let .original(feed):
            return feed.timestamp
        }
    }

    var isDateExists: Bool {
        timestamp != nil
    }

    var fill: some ShapeStyle {
        isDateExists ? Color.primary.gradient : Color.secondary.gradient
    }
}
