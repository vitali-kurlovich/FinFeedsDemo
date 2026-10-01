//
//  Created by Kurlovich Vitali on 9/30/26.
//

import Caches

enum CachesLocator {
    static let pricesCache = PersistentCache(
        named: "price_feeds",
        keyType: String.self,
        valueType: SymbolPrice.self
    )
}
