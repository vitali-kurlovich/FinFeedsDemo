//
//  Created by Kurlovich Vitali on 10/5/26.
//

import TwelveDataREST

nonisolated struct TwelveDataCryptoPairsService: CryptoPairsService {
    let apiKeyService: any ApiKeyService

    func cryptoPairs() async throws(RestError) -> [CryptoPair] {
        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.cryptoPairs()
            return response.data.map { pair in
                CryptoPair(pair)
            }

        } catch {
            throw RestError(error)
        }
    }
}
