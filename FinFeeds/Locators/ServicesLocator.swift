//
//  Created by Kurlovich Vitali on 9/29/26.
//

import DataLayer
import TwelveDataAdapter

struct ServicesLocator {
    private init() {}
}

extension ServicesLocator {
    static let apiKeyService: any TwelveDataApiKeyService = TwelveDataApiKey()
    
    static let locator = TwelveDataServiceLocator(apiKeyService: Self.apiKeyService)
    
}


extension ServicesLocator {
    static var symbolPriceService: any SymbolPriceService {
        locator.symbolPriceService
    }

    static var connectivityService: any ConnectivityService {
        locator.connectivityService
    }

    static var forexService: any ForexPairsService {
        locator.forexService
    }

    static var cryptoService: any CryptoPairsService {
        locator.cryptoService
    }

    static var stockService: any StocksService {
        FakeStocks()
    }

    static var commoditiesService: any CommoditiesPairsService {
        locator.commoditiesService
    }
}

extension ServicesLocator {
    static let loggingService: any LoggingService = LoggingServiceAdapter()
}

extension ServicesLocator {
    static let swiftDataSync = SwiftDataSync()
}
