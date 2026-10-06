//
//  Created by Kurlovich Vitali on 9/29/26.
//

import TwelveDataStream

extension TwelveDataSymbolPriceAdapter: ConnectivityService {
    var connectivity: AsyncStream<ConnectivityState> {
        connectivityService.connectivity
    }
}

nonisolated struct TwelveDataSymbolPriceAdapter: SymbolPriceService, Sendable {
    private let repository: TwelveDataSymbolPriceRepository
    private let connectivityService: TwelveDataConnectivityAdapter

    init(apiKeyService: any TwelveDataApiKeyService) {
        let apiKey = apiKeyService.apiKey
        let websocket = TwelveDataWebsocket(apiKey: apiKey)

        connectivityService = TwelveDataConnectivityAdapter(socket: websocket)

        repository = TwelveDataSymbolPriceRepository(
            websocket,
            apiKeyService: apiKeyService
        )
    }

    var prices: AsyncStream<SymbolPrice> {
        return AsyncStream<SymbolPrice>(
            bufferingPolicy: .bufferingNewest(1)
        ) { continuation in
            let task = Task {

                let stream = await repository.prices

                for await price in stream {
                    continuation.yield(price)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    func subsribe(_ symbols: Set<String>) {
        Task {
            await repository.subsribe(symbols)
        }
    }

    func unsubsribe(_ symbols: Set<String>) {
        Task {
            await repository.unsubsribe(symbols)
        }
    }
}

private actor TwelveDataSymbolPriceRepository {
    private let socket: TwelveDataWebsocket
    private let subscriptionReducer = CountedSetReducer<String>()

    private let apiKeyService: any TwelveDataApiKeyService

    private var updateApiKeyTask: Task<Void, Never>?

    deinit {
        updateApiKeyTask?.cancel()
    }

    init(_ socket: TwelveDataWebsocket, apiKeyService: any TwelveDataApiKeyService) {
        self.socket = socket
        self.apiKeyService = apiKeyService
        Task {
            await invalidateApiKey()
            await subscribeApiKeyUpdate()
        }
    }

    func subscribeApiKeyUpdate() {
        updateApiKeyTask = Task {
            for await _ in apiKeyService.updates {
                await invalidateApiKey()
            }
        }
    }

    func invalidateApiKey() async {
        let apiKey = apiKeyService.apiKey

        await socket.update(apiKey: apiKey)

        //    socket.configuration.apiKey = apiKeyService.apiKey
    }

    var prices: AsyncStream<SymbolPrice> {
        return AsyncStream<SymbolPrice> { continuation in
            let task = Task {

                let stream = await socket.prices

                for await price in stream {
                    let price = SymbolPrice(price)
                    continuation.yield(price)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    func subsribe(_ symbols: Set<String>) {
        let symbols = subscriptionReducer.insert(symbols)
        guard symbols.isEmpty == false else {
            return
        }

        Task {
            await socket.subscribe(symbols: symbols)
        }
    }

    func unsubsribe(_ symbols: Set<String>) {
        let symbols = subscriptionReducer.remove(symbols)
        guard symbols.isEmpty == false else {
            return
        }

        Task {
            await socket.unsubscribe(symbols: symbols)
        }
    }
}

extension SymbolPrice {
    nonisolated init(_ event: TwelvedataPriceEvent) {
        self.init(
            symbol: event.symbol,
            timestamp: event.timestamp,
            price: event.price
        )
    }
}
