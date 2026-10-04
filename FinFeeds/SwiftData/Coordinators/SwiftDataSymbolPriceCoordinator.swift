//
//  Created by Kurlovich Vitali on 10/3/26.
//

import Foundation
import SwiftData
import SwiftUI

extension EnvironmentValues {
    @Entry var swiftDataSymbolPriceCoordinator = SwiftDataSymbolPriceCoordinator()
}

final class SwiftDataSymbolPriceCoordinator {
    var recieveTask: Task<Void, Never>?

    deinit {
        recieveTask?.cancel()
    }

    func stop() {
        recieveTask?.cancel()
        recieveTask = nil
    }

    func start(service: any SymbolPriceService, context: ModelContext) {
        func update(with symbolPrice: SymbolPrice, in context: ModelContext) throws {
            let predicate = #Predicate<Feed> { feed in
                feed.symbol == symbolPrice.symbol
            }

            var descriptor = FetchDescriptor<Feed>(predicate: predicate)
            descriptor.fetchLimit = 1

            if let feed = try context.fetch(descriptor).first {
                if let price = feed.price {
                    price.price = symbolPrice.price
                    price.timestamp = symbolPrice.timestamp
                } else {
                    feed.price = Price(price: symbolPrice.price, timestamp: symbolPrice.timestamp)
                }

            } else {
                let price = Price(price: symbolPrice.price, timestamp: symbolPrice.timestamp)

                let feed = Feed(symbol: symbolPrice.symbol, price: price)

                context.insert(feed)
            }

            try context.save()
        }

        recieveTask = Task { [service, context] in
            do {
                for await symbolPrice in service.prices {
                    try update(with: symbolPrice, in: context)
                }

            } catch {
                // TODO: Logging errors
            }
        }
    }
}
