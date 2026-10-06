//
//  Created by Kurlovich Vitali on 10/4/26.
//

import DataLayer
import TwelveDataREST

nonisolated struct TwelveDataForexPairsService: ForexPairsService {
    let apiKeyService: any TwelveDataApiKeyService

    func forexPairs() async throws(FetchError) -> [ForexPair] {
        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.forexPairs()
            return response.data.map { pair in
                ForexPair(pair)
            }

        } catch {
            throw FetchError(error)
        }
    }
}
