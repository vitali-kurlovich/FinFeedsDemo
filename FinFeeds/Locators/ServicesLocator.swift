//
//  Created by Kurlovich Vitali on 9/29/26.
//

import TwelveData

struct ServicesLocator {
    private static let websocket: TwelveDataWebsocket = .init(apiKey: "6cf1d9292bb94c7fab1445e06e6d901e")

    private init() {}
}

extension ServicesLocator {
    static let connectivityService: any ConnectivityService = TwelveDataConnectivityAdapter(socket: websocket)
}

extension ServicesLocator {
    static let symbolPriceService: any SymbolPriceService = TwelveDataSymbolPriceAdapter(websocket)
}

extension ServicesLocator {
    static let symbolPriceFeedsService: any SymbolPriceFeedsService = {
        let service = SymbolPriceFeedCollectorService(
            service: Self.symbolPriceService,
            connectivity: Self.connectivityService,
            cache: CachesLocator.pricesCache
        )
        return SymbolPriceFeedsAdapter(service)
    }()
}

extension ServicesLocator {
    static let loggingService: any LoggingService = LoggingServiceAdapter()
}
