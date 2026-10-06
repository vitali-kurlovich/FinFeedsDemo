//
//  Created by Kurlovich Vitali on 10/5/26.
//

import TwelveDataREST

struct TwelveDataStocksService: StocksService {
    let apiKeyService: any TwelveDataApiKeyService

    func stocks() async throws(FetchError) -> [StockInstrument] {
        return ["AAPL", "RY:TSX", "TSLA"].map { StockInstrument(symbol: Symbol($0)) }

        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.stocks()
            return response.data.map { pair in
                StockInstrument(pair)
            }

        } catch {
            throw FetchError(error)
        }
    }
}
