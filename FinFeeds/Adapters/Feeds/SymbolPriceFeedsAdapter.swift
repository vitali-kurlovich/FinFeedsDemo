//
//  Created by Kurlovich Vitali on 10/1/26.
//

import Caches

struct SymbolPriceFeedsAdapter<Cache: CacheProtocol & Sendable>: SymbolPriceFeedsService where Cache.Key == String, Cache.Value == SymbolPrice {
    typealias SymbolPriceFeedsStream = AsyncStream<[SymbolPriceFeed]>

    let service: SymbolPriceFeedCollectorService<Cache>

    init(_ service: SymbolPriceFeedCollectorService<Cache>) {
        self.service = service
    }

    var feeds: AsyncStream<[SymbolPriceFeed]> {
        AsyncStream<[SymbolPriceFeed]> { continuation in
            let task = Task {
                for await feed in await service.feeds {
                    continuation.yield(feed)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    func subsribe(_ symbols: Set<String>) {
        Task {
            await service.subsribe(symbols)
        }
    }

    func unsubsribe(_ symbols: Set<String>) {
        Task {
            await service.unsubsribe(symbols)
        }
    }
}
