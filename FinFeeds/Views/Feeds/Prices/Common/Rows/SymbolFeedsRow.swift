//
//  Created by Kurlovich Vitali on 10/3/26.
//

import DataLayer
import Foundation
import SwiftData
import SwiftUI

struct SymbolFeedsRow: View {
    private let update: FeedsUpdate

    @Environment(\.symbolPriceService)
    private var service

    init(_ update: FeedsUpdate) {
        self.update = update
    }

    var body: some View {
        Text(text)
            .foregroundStyle(fill)
            .contentTransition(.interpolate)
            .onAppear {
                service.subsribe([update.symbol.id])
            }
            .onDisappear {
                service.unsubsribe([update.symbol.id])
            }
            .animation(.bouncy, value: update)
    }
}

private extension SymbolFeedsRow {
    var text: String {
        update.symbol.description
    }

    var isPriceExists: Bool {
        update.price != nil
    }

    var fill: some ShapeStyle {
        isPriceExists ? Color.primary.gradient : Color.secondary.gradient
    }
}
