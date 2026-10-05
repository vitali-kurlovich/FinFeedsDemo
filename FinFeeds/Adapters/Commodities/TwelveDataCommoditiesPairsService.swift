//
//  Created by Kurlovich Vitali on 10/5/26.
//

import TwelveDataREST

nonisolated struct TwelveDataCommoditiesPairsService: CommoditiesPairsService {
    let apiKeyService: any ApiKeyService

    func commodities() async throws(RestError) -> [CommoditiesPair] {
        do {
            let rest = TwelveDataREST(apiKey: apiKeyService.apiKey)

            let response = try await rest.commodities()
            return response.data.map { pair in
                CommoditiesPair(pair)
            }

        } catch {
            throw RestError(error)
        }
    }
}
