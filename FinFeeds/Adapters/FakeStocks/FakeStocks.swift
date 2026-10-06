//
//  Created by Kurlovich Vitali on 10/6/26.
//

import DataLayer


nonisolated struct FakeStocks: StocksService {
    func stocks() async throws(DataLayer.FetchError) -> [DataLayer.StockInstrument] {
        return ["AAPL", "RY:TSX", "TSLA"].map { StockInstrument(symbol: Symbol($0)) }
    }

    
}
