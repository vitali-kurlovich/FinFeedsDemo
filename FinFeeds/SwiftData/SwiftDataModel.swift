//
//  Created by Kurlovich Vitali on 10/3/26.
//

import Foundation
import SwiftData

enum PersistentModels {
    static var persistentModels: [any PersistentModel.Type] {
        [
            FeedsSubscriptions.self,
            Feed.self,
            SymbolsStorage.self,
        ]
    }
}

enum SymbolType: String, Codable, Hashable, Sendable, CaseIterable {
    case forex
    case crypto
    case stock
    case commodities
}

@Model
final class SymbolsStorage {
    var typeRaw: String

    var type: SymbolType {
        get {
            SymbolType(rawValue: typeRaw) ?? .forex
        }
        set {
            typeRaw = newValue.rawValue
        }
    }

    var symbols: Set<String>
    var lastLoadedPage: Int?
    var lastUpdate: Date

    init(type: SymbolType, symbols: Set<String>, lastUpdate: Date) {
        typeRaw = type.rawValue
        self.symbols = symbols
        self.lastUpdate = lastUpdate
    }
}

@Model
final class FeedsSubscriptions {
    var name: String
    var subscriptions: Set<String>

    init(name: String, subscriptions: Set<String>) {
        self.name = name
        self.subscriptions = subscriptions
    }
}

@Model
final class Feed {
    @Attribute(.unique)
    var symbol: String

    var price: Decimal?
    var timestamp: Date?

    init(symbol: String, price: Decimal? = nil, timestamp: Date? = nil) {
        self.symbol = symbol
        self.price = price
        self.timestamp = timestamp
    }
}
