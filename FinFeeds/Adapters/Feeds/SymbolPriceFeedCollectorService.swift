//
//  Created by Kurlovich Vitali on 9/29/26.
//

import Caches

actor SymbolPriceFeedCollectorService<Cache: CacheProtocol>
    where Cache.Key == String, Cache.Value == SymbolPrice
{
    let service: any SymbolPriceService
    let connectivity: any ConnectivityService

    private var connectivityTask: Task<Void, Never>?
    private var priceTask: Task<Void, Never>?

    private var feedsCollectror = IdentifiableCollector<SymbolPriceFeed>()
    private var consumersCount = 0

    private let priceFeedsStream: AsyncStream<[SymbolPriceFeed]>
    private let priceFeedsContinuation: AsyncStream<[SymbolPriceFeed]>.Continuation

    private let cache: Cache

    init(
        service: any SymbolPriceService,
        connectivity: any ConnectivityService,
        cache: Cache
    ) {
        self.service = service
        self.connectivity = connectivity
        self.cache = cache

        (priceFeedsStream, priceFeedsContinuation) = AsyncStream<[SymbolPriceFeed]>.makeStream()
    }

    func subsribe(_ symbols: Set<String>) {
        let existsSymbols = feedsCollectror.map { $0.symbol }

        let needsLoadFromCache = symbols.subtracting(existsSymbols)

        for symbol in needsLoadFromCache {
            if let price = cache.pull(key: symbol) {
                _ = feedsCollectror.updateOrAppend(.cached(price))
            } else {
                _ = feedsCollectror.updateOrAppend(.none(symbol))
            }
        }

        service.subsribe(symbols)

        invalidateFeeds()
    }

    func unsubsribe(_ symbols: Set<String>) {
        service.unsubsribe(symbols)
    }

    var feeds: AsyncStream<[SymbolPriceFeed]> {
        prepareIfNeeds()
        return AsyncStream<[SymbolPriceFeed]> { continuation in
            let task = Task {

                let feeds = feedsCollectror.sorted(by: \.symbol)
                continuation.yield(feeds)

                for await feeds in priceFeedsStream {
                    continuation.yield(feeds)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

private extension SymbolPriceFeedCollectorService {
    func invalidateFeeds() {
        let feeds = feedsCollectror.sorted(by: \.symbol)
        priceFeedsContinuation.yield(feeds)
    }

    func performOffline() {
        let changed = feedsCollectror.update { feed in
            switch feed {
            case .none, .cached:
                return feed
            case let .live(price):
                return .cached(price)
            }
        }

        if changed {
            invalidateFeeds()
        }
    }

    func prepareIfNeeds() {
        guard connectivityTask == nil, priceTask == nil else {
            return
        }

        connectivityTask = Task {
            for await state in connectivity.connectivity {
                if state != .connected {
                    performOffline()
                }
            }
        }

        priceTask = Task {
            for await price in service.prices {
                cache.push(key: price.id, value: price)

                let changed = feedsCollectror.updateOrAppend(.live(price))
                if changed {
                    invalidateFeeds()
                }
            }
        }
    }

    func stop() {
        priceTask?.cancel(); priceTask = nil
        connectivityTask?.cancel(); connectivityTask = nil
    }
}
