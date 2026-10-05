//
//  Created by Kurlovich Vitali on 10/4/26.
//

import TwelveDataREST

struct TwelveDataForexPairsService: ForexPairsService {
    let apiKeyService: any ApiKeyService

    func forexPairs() async throws(RestError) -> [ForexPair] {
        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.forexPairs()
            return response.data.map { pair in
                ForexPair(pair)
            }

        } catch {
            throw RestError(error)
        }
    }
}
