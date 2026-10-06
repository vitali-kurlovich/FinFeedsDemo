//
//  Created by Kurlovich Vitali on 10/4/26.
//

import DataLayer
import TwelveDataREST

extension ForexPair {
    nonisolated init(_ pair: TwelveDataForexPair) {
        self.init(symbol: Symbol(pair.symbol))
    }
}
