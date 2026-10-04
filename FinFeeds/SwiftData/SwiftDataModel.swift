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
            ForexPairModel.self,
            ForexPairsStorage.self,
        ]
    }
}

@Model
final class ForexPairModel {
    var symbol: String

    init(symbol: String) {
        self.symbol = symbol
    }
}

@Model
final class ForexPairsStorage {
    var pairs: [ForexPairModel]

    init(pairs: [ForexPairModel]) {
        self.pairs = pairs
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
