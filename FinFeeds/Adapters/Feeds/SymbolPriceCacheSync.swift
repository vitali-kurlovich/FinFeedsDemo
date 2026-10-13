//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import DataLayer
import SwiftData
import SwiftUI

extension EnvironmentValues {
    @Entry var priceCacheSync = SymbolPriceCacheSync(context: nil)
}

struct SymbolPriceCacheSync {
    let context: ModelContext?

    func callAsFunction() async {
        guard let context else {
            assertionFailure()
            return
        }

        let cache = SymbolPriceCache(context: context)

        let updater = SymbolPriceCacheUpdater(cache) { _ in
            // TODO: Logging error
        }

        await updater.watch(prices: ServicesLocator.symbolPriceService.prices)
    }
}
