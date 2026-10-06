//
//  Created by Kurlovich Vitali on 10/5/26.
//

import TwelveDataREST

nonisolated struct TwelveDataCryptoPairsService: CryptoPairsService {
    let apiKeyService: any TwelveDataApiKeyService

    func cryptoPairs() async throws(FetchError) -> [CryptoPair] {
        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.cryptoPairs()
            return response.data.map { pair in
                CryptoPair(pair)
            }

        } catch {
            throw FetchError(error)
        }
    }
}
