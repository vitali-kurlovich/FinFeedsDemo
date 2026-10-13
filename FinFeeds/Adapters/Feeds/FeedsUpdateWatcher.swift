//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import DataLayer
import SwiftData
import SwiftUI

extension EnvironmentValues {
    @Entry var feedsUpdateWatcher = FeedsUpdateWatcher(context: nil)
}

struct FeedsUpdateWatcher {
    let context: ModelContext?

    func callAsFunction(symbol: Symbol) -> AsyncStream<CachableItem<FeedsUpdate>> {
        guard let context else {
            assertionFailure()
            return AsyncStream<CachableItem<FeedsUpdate>>() { continuation in
                continuation.finish()
            }
        }

        let cache = SymbolPriceCache(context: context).map { price in
            FeedsUpdate(price)
        }

        let subscriber = SymbolPriceFeedsAutoSubscriber(
            subscriber: ServicesLocator.feedsSuscriberService,
            service: ServicesLocator.symbolPriceService,
            cache
        )

        return subscriber.watch(symbol: symbol)
    }
}
