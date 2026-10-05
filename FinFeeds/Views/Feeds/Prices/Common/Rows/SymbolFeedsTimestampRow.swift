//
//  Created by Kurlovich Vitali on 10/3/26.
//

import SwiftData
import SwiftUI

struct SymbolFeedsTimestampRow: View, Equatable {
    private let update: FeedsUpdate

    init(_ update: FeedsUpdate) {
        self.update = update
    }

    var body: some View {
        Text(text)
            .foregroundStyle(fill)
            .contentTransition(.interpolate)
            .animation(.bouncy, value: update)
    }
}

private extension SymbolFeedsTimestampRow {
    var text: String {
        timestamp?
            .formatted(.dateTime.month().day().hour().minute()) ?? "-"
    }

    var timestamp: Date? {
        update.timestamp
    }

    var isDateExists: Bool {
        timestamp != nil
    }

    var fill: some ShapeStyle {
        isDateExists ? Color.primary.gradient : Color.secondary.gradient
    }
}
