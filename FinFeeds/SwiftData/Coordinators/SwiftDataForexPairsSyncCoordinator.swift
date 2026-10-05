//
//  Created by Kurlovich Vitali on 10/4/26.
//

import Foundation
import SwiftData

nonisolated struct SwiftDataForexPairsSyncCoordinator: Sendable {
    func sync(context: ModelContext, service: any ForexPairsService) async throws {
        let forexTypeRaw = SymbolType.forex.rawValue

        let predicate = #Predicate<SymbolsStorage> {
            $0.typeRaw == forexTypeRaw
        }

        var descriptor = FetchDescriptor<SymbolsStorage>(predicate: predicate)
        descriptor.fetchLimit = 1

        let storage = try context.fetch(descriptor).first

        if let storage, storage.lastUpdate.addingTimeInterval(24 * 60 * 60) > .now {
            return
        }

        let liveData = try await service.forexPairs()

        let symbols = Set(liveData.map {
            $0.symbol.id
        })

        if let storage {
            storage.symbols = symbols
            storage.lastUpdate = .now
        } else {
            let storage = SymbolsStorage(type: .forex, symbols: symbols, lastUpdate: .now)
            context.insert(storage)
        }

        try context.save()
    }
}
