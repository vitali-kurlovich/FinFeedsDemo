//
//  Created by Kurlovich Vitali on 10/5/26.
//

import Foundation
import SwiftData

nonisolated struct SwiftDataStocksSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any StocksService) async throws {
        let resolver = SwiftDataSymbolsStorageSyncResolver()

        try await resolver
            .sync(context: context, for: .stock, skipSyncInterval: TimeInterval(24 * 60 * 60)) {
                let liveData = try await service.stocks()

                return Set(liveData.map {
                    $0.symbol.id
                })
            }
    }
}
