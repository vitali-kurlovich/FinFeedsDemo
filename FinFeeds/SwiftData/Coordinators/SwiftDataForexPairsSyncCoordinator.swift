//
//  Created by Kurlovich Vitali on 10/4/26.
//

import Foundation
import SwiftData
import SwiftUI

extension EnvironmentValues {
    @Entry var swiftDataForexPairsSyncCoordinator = SwiftDataForexPairsSyncCoordinator()
}

nonisolated struct SwiftDataForexPairsSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any ForexPairsService) async throws {
        let liveData = try await service.forexPairs()

        var descriptor = FetchDescriptor<ForexPairsStorage>()
        descriptor.fetchLimit = 1

        let pairs = liveData.map { pair in
            ForexPairModel(symbol: pair.symbol.id)
        }

        if let storage = try context.fetch(descriptor).first {
            storage.pairs = pairs
        } else {
            let storage = ForexPairsStorage(pairs: pairs)
            context.insert(storage)
        }

        try context.save()
    }
}
