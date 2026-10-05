//
//  Created by Kurlovich Vitali on 10/4/26.
//

import Foundation
import SwiftData

nonisolated struct SwiftDataForexPairsSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any ForexPairsService) async throws {
        let resolver = SwiftDataStorageResolver()

        let storage = try resolver.storage(context: context, for: .forex)

        if let storage, storage.lastUpdate.addingTimeInterval(24 * 60 * 60) > .now {
            return
        }

        let liveData = try await service.forexPairs()

        let symbols = Set(liveData.map {
            $0.symbol.id
        })

        try resolver.save(context: context, symbols: symbols, for: .forex)
    }
}
