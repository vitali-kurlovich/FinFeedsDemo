//
//  Created by Kurlovich Vitali on 10/12/26.
//

import CoreLayer
import DataLayer
import Foundation
import SwiftData

enum SymbolPriceCacheError: Error {
    case writeError(String)
    case readError(String)

    var localizedDescription: String {
        switch self {
        case let .readError(description):
            return description
        case let .writeError(description):
            return description
        }
    }
}

nonisolated struct SymbolPriceCache: @unchecked Sendable {
    let context: ModelContext
}

extension SymbolPriceCache: KeyValueStorageReader<Symbol, SymbolPrice, SymbolPriceCacheError> {
    func readValue(by key: Symbol) async throws(SymbolPriceCacheError) -> DataLayer.SymbolPrice? {
        let predicate = #Predicate<Feed> { feed in
            feed.symbol == key.id
        }

        var descriptor = FetchDescriptor<Feed>(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            guard let feed = try context.fetch(descriptor).first,
                  let price = feed.price,
                  let timestamp = feed.timestamp
            else {
                return nil
            }

            let symbol = Symbol(feed.symbol)
            return SymbolPrice(symbol: symbol, timestamp: timestamp, price: price)

        } catch {
            throw SymbolPriceCacheError.readError(error.localizedDescription)
        }
    }
}

extension SymbolPriceCache: KeyValueStorageWriter<Symbol, SymbolPrice, SymbolPriceCacheError> {
    func write(by key: Symbol, value: SymbolPrice?) async throws(SymbolPriceCacheError) {
        let predicate = #Predicate<Feed> { feed in
            feed.symbol == key.id
        }

        var descriptor = FetchDescriptor<Feed>(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            guard let value else {
                if let feed = try context.fetch(descriptor).first {
                    context.delete(feed)
                    if context.hasChanges {
                        try context.save()
                    }
                }
                return
            }

            if let feed = try context.fetch(descriptor).first {
                feed.price = value.price
                feed.timestamp = value.timestamp

            } else {
                let feed = Feed(
                    symbol: value.symbol.id,
                    price: value.price,
                    timestamp: value.timestamp
                )

                context.insert(feed)
            }

            if context.hasChanges {
                try context.save()
            }
        } catch {
            throw SymbolPriceCacheError.writeError(error.localizedDescription)
        }
    }
}
