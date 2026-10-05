//
//  Created by Kurlovich Vitali on 10/5/26.
//

import Foundation
import SwiftData

nonisolated struct SwiftDataCryptoPairsSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any CryptoPairsService) async throws {
        let resolver = SwiftDataStorageResolver()

        let storage = try resolver.storage(context: context, for: .crypto)

        if let storage, storage.lastUpdate.addingTimeInterval(24 * 60 * 60) > .now {
            return
        }

        let liveData = try await service.cryptoPairs()

        let symbols = Set(liveData.map {
            $0.symbol.id
        })

        try resolver.save(context: context, symbols: symbols, for: .crypto)
    }
}
