//
//  Created by Kurlovich Vitali on 10/5/26.
//

import DataLayer
import Foundation
import SwiftData

nonisolated struct SwiftDataCryptoPairsSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any CryptoPairsService) async throws {
        let resolver = SwiftDataSymbolsStorageSyncResolver()

        try await resolver
            .sync(context: context, for: .crypto, skipSyncInterval: TimeInterval(24 * 60 * 60)) {
                let liveData = try await service.cryptoPairs()

                return Set(liveData.map {
                    $0.symbol.id
                })
            }
    }
}
