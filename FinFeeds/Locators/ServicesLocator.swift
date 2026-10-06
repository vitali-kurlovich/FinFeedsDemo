//
//  Created by Kurlovich Vitali on 9/29/26.
//

import DataLayer

struct ServicesLocator {
    private init() {}
}

extension ServicesLocator {
    static let apiKeyService: any TwelveDataApiKeyService = TwelveDataApiKey()
}

extension ServicesLocator {
    private static let twelveDataSymbolPriceService = TwelveDataSymbolPriceAdapter(
        apiKeyService: apiKeyService
    )
}

extension ServicesLocator {
    static var symbolPriceService: any SymbolPriceService {
        twelveDataSymbolPriceService
    }
}

extension ServicesLocator {
    static var connectivityService: any ConnectivityService {
        twelveDataSymbolPriceService
    }
}

extension ServicesLocator {
    static let loggingService: any LoggingService = LoggingServiceAdapter()
}

extension ServicesLocator {
    static let forexService: any ForexPairsService = TwelveDataForexPairsService(
        apiKeyService: apiKeyService
    )
}

extension ServicesLocator {
    static let cryptoService: any CryptoPairsService = TwelveDataCryptoPairsService(
        apiKeyService: apiKeyService
    )
}

extension ServicesLocator {
    static let stockService: any StocksService = TwelveDataStocksService(
        apiKeyService: apiKeyService
    )
}

extension ServicesLocator {
    static let commoditiesService: any CommoditiesPairsService = TwelveDataCommoditiesPairsService(
        apiKeyService: apiKeyService
    )
}

extension ServicesLocator {
    static let swiftDataSync = SwiftDataSync()
}
