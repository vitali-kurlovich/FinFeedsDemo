//
//  Created by Kurlovich Vitali on 10/3/26.
//

import DataLayer
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
                feed.price = symbolPrice.price
                feed.timestamp = symbolPrice.timestamp

            } else {
                let feed = Feed(
                    symbol: symbolPrice.symbol,
                    price: symbolPrice.price,
                    timestamp: symbolPrice.timestamp
                )

                context.insert(feed)
            }

            try context.save()
            // TODO: Logging
            print("Save feed update")
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
