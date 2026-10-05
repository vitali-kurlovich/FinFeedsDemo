//
//  Created by Kurlovich Vitali on 10/5/26.
//

import TwelveDataREST

extension CommoditiesPair {
    nonisolated init(_ commodity: TwelveDataCommodity) {
        self.init(symbol: Symbol(commodity.symbol))
    }
}
