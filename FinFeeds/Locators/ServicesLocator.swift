//
//  Created by Kurlovich Vitali on 9/29/26.
//

import TwelveData

struct ServicesLocator {
    private init() {}
}

extension ServicesLocator {
    static let apiKeyService: any ApiKeyService = TwelveDataApiKey()
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
