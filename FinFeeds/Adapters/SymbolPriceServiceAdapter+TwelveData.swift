//
//  Created by Kurlovich Vitali on 9/29/26.
//

import TwelveData

nonisolated struct TwelveDataSymbolPriceAdapter: SymbolPriceService, Sendable {
    private let socket: TwelveDataWebsocket
    private let subscriptionReducer = CountedSetReducer<String>()

    init(_ socket: TwelveDataWebsocket) {
        self.socket = socket
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
