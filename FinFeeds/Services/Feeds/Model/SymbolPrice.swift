//
//  Created by Kurlovich Vitali on 9/29/26.
//

import Foundation

nonisolated struct SymbolPrice: Equatable, Codable, Sendable {
    var symbol: String
    var timestamp: Date
    var price: Decimal
}

extension SymbolPrice: Identifiable {
    nonisolated var id: String {
        symbol
    }
}

extension SymbolPrice: CustomStringConvertible {
    var description: String {
        "{ symbol:\(symbol), timestamp:\(timestamp), price:\(price) }"
    }
}
