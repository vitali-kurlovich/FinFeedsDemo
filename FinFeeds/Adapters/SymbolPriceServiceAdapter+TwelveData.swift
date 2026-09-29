//
//  Created by Kurlovich Vitali on 9/29/26.
//

import TwelveData

extension ServicesLocator {
    static var symbolPriceService: any SymbolPriceService {
        TwelveDataSymbolPriceService(socket: websocket)
    }
}

struct TwelveDataSymbolPriceService: SymbolPriceService, Sendable {
    let socket: TwelveDataWebsocket

    var symbolPriceStream: AsyncStream<SymbolPrice> {
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

    func subsribe(symbols: Set<String>) {
        Task {
            await socket.subscribe(symbols: symbols)
        }
    }

    func unsubsribe(symbols: Set<String>) {
        Task {
            await socket.unsubscribe(symbols: symbols)
        }
    }
}

extension SymbolPrice {
    init(_ event: TwelvedataPriceEvent) {
        self.init(
            symbol: event.symbol,
            timestamp: event.timestamp,
            price: event.price
        )
    }
}
