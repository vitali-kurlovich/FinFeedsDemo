//
//  Created by Kurlovich Vitali on 10/5/26.
//

import Foundation
import SwiftData

final class SwiftDataSync {
    private enum SyncState: Hashable, Sendable {
        case idle
        case inProgress
        case ready
        case fail
    }

    private var syncState: [SymbolType: SyncState] = [
        .forex: .idle,
        .crypto: .idle,
        .stock: .idle,
        .commodities: .idle,
    ]
}

extension SwiftDataSync {
    func sync(context: ModelContext, with service: any ForexPairsService) async throws {
        try await syncCoreData(context: context, for: .forex) {
            let coordinator = SwiftDataForexPairsSyncCoordinator()

            try await coordinator
                .sync(context: context, service: service)
        }
    }

    func sync(context: ModelContext, with service: any CryptoPairsService) async throws {
        try await syncCoreData(context: context, for: .crypto) {
            let coordinator = SwiftDataCryptoPairsSyncCoordinator()

            try await coordinator
                .sync(context: context, service: service)
        }
    }

    func sync(context: ModelContext, with service: any StocksService) async throws {
        try await syncCoreData(context: context, for: .stock) {
            let coordinator = SwiftDataStocksSyncCoordinator()

            try await coordinator
                .sync(context: context, service: service)
        }
    }

    func sync(context: ModelContext, with service: any CommoditiesPairsService) async throws {
        try await syncCoreData(context: context, for: .commodities) {
            let coordinator = SwiftDataCommoditiesSyncCoordinator()

            try await coordinator
                .sync(context: context, service: service)
        }
    }
}

private extension SwiftDataSync {
    private func needsSync(for type: SymbolType) -> Bool {
        assert(syncState[type] != nil)
        return syncState[type] == .idle || syncState[type] == .fail
    }

    private func syncCoreData(
        context _: ModelContext,
        for type: SymbolType,
        sync: () async throws -> Void
    ) async throws {
        guard needsSync(for: type) else {
            return
        }

        do {
            syncState[type] = .inProgress
            try await sync()
            syncState[type] = .ready
        } catch {
            syncState[type] = .fail
            throw error
        }
    }
}
