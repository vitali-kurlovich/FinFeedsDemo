//
//  Created by Kurlovich Vitali on 10/5/26.
//

import DataLayer
import TwelveDataREST

extension CryptoPair {
    nonisolated init(_ pair: TwelveDataCryptoPair) {
        self.init(symbol: Symbol(pair.symbol))
    }
}
