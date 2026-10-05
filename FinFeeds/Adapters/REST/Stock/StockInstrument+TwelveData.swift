//
//  Created by Kurlovich Vitali on 10/5/26.
//

import TwelveDataREST

extension StockInstrument {
    nonisolated init(_ stock: TwelveDataStock) {
        self.init(symbol: Symbol(stock.symbol))
    }
}
