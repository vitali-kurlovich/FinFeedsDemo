//
//  Created by Kurlovich Vitali on 10/5/26.
//

import TwelveDataREST

struct TwelveDataStocksService: StocksService {
    let apiKeyService: any ApiKeyService

    func stocks() async throws(RestError) -> [StockInstrument] {
        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.stocks()
            return response.data.map { pair in
                StockInstrument(pair)
            }

        } catch {
            throw RestError(error)
        }
    }
}
