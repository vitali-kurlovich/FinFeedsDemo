//
//  SwiftDataModel.swift
//  FinFeeds
//
//  Created by Kurlovich Vitali on 10/3/26.
//

import Foundation
import SwiftData

enum PersistentModels {
    static var persistentModels: [any PersistentModel.Type] {
        [
            FeedsSubscriptions.self,
            Price.self,
            Feed.self,
            SymbolsStorage.self,
        ]
    }
}

enum SymbolType: String, Codable {
    case forex
    case crypto
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
final class Price {
    // var symbol: String
    var price: Decimal
    var timestamp: Date

    init(price: Decimal, timestamp: Date) {
        self.price = price
        self.timestamp = timestamp
    }
}

@Model
final class Feed {
    var symbol: String
    var price: Price?

    init(symbol: String, price: Price? = nil) {
        self.symbol = symbol
        self.price = price
    }
}
