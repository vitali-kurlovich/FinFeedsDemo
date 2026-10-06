//
//  Created by Kurlovich Vitali on 10/4/26.
//

import DataLayer
import Foundation
import SwiftData

nonisolated struct SwiftDataForexPairsSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any ForexPairsService) async throws {
        let resolver = SwiftDataSymbolsStorageSyncResolver()

        try await resolver
            .sync(context: context, for: .forex, skipSyncInterval: TimeInterval(24 * 60 * 60)) {
                let liveData = try await service.forexPairs()

                return Set(liveData.map {
                    $0.symbol.id
                })
            }
    }
}
