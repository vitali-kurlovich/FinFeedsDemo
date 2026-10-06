//
//  Created by Kurlovich Vitali on 10/5/26.
//

import DataLayer
import TwelveDataREST

nonisolated struct TwelveDataCommoditiesPairsService: CommoditiesPairsService {
    let apiKeyService: any TwelveDataApiKeyService

    func commodities() async throws(FetchError) -> [CommoditiesPair] {
        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.commodities()
            return response.data.map { pair in
                CommoditiesPair(pair)
            }

        } catch {
            throw FetchError(error)
        }
    }
}
