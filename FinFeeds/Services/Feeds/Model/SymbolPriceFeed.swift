//
//  Created by Kurlovich Vitali on 9/29/26.
//

import struct Foundation.Date

nonisolated enum SymbolPriceFeed: Equatable, Sendable, Identifiable {
    case none(String)
    case cached(SymbolPrice)
    case live(SymbolPrice)

    var id: String {
        symbol
    }
}

extension SymbolPriceFeed {
    nonisolated var symbol: String {
        switch self {
        case let .none(symbol):
            return symbol

        case let .cached(price):
            return price.symbol

        case let .live(price):
            return price.symbol
        }
    }

    nonisolated var timestamp: Date? {
        switch self {
        case .none:
            return nil

        case let .cached(price):
            return price.timestamp

        case let .live(price):
            return price.timestamp
        }
    }
}
