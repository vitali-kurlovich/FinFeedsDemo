//
//  Created by Kurlovich Vitali on 10/5/26.
//

import Foundation
import SwiftData


nonisolated struct SwiftDataCommoditiesSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any CommoditiesPairsService) async throws {
        let resolver = SwiftDataSymbolsStorageSyncResolver()

        try await resolver
            .sync(
                context: context,
                for: .commodities,
                skipSyncInterval: TimeInterval(24 * 60 * 60)
            ) {
                let liveData = try await service.commodities()

                return Set(liveData.map {
                    $0.symbol.id
                })
            }
    }
}
