//
//  Created by Kurlovich Vitali on 10/5/26.
//

import Foundation
import SwiftData

nonisolated struct SwiftDataSymbolsStorageSyncResolver {}

extension SwiftDataSymbolsStorageSyncResolver {
    nonisolated func storage(context: ModelContext, for type: SymbolType) throws -> SymbolsStorage? {
        // let typeRaw = type.rawValue

        let predicate = #Predicate<SymbolsStorage> {
            $0.type == type
        }

        var descriptor = FetchDescriptor<SymbolsStorage>(predicate: predicate)
        descriptor.fetchLimit = 1

        return try context.fetch(descriptor).first
    }

    nonisolated func save(context: ModelContext, symbols: Set<String>, for type: SymbolType) throws {
        if let storage = try storage(context: context, for: type) {
            storage.symbols = symbols
            storage.lastUpdate = .now
        } else {
            let storage = SymbolsStorage(type: type, symbols: symbols, lastUpdate: .now)
            context.insert(storage)
        }

        try context.save()
    }
}

extension SwiftDataSymbolsStorageSyncResolver {
    nonisolated func sync(context: ModelContext,
                          for type: SymbolType,
                          skipSyncInterval: TimeInterval = 0,
                          fetch: () async throws -> Set<String>) async throws
    {
        let storage = try storage(context: context, for: type)

        if skipSyncInterval > 0, let storage, storage.lastUpdate.addingTimeInterval(skipSyncInterval) > .now {
            return
        }

        let symbols = try await fetch()

        try save(context: context, symbols: symbols, for: type)
    }
}
