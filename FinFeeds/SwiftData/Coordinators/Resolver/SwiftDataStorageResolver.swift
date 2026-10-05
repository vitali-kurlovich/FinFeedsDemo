//
//  Created by Kurlovich Vitali on 10/5/26.
//

import Foundation
import SwiftData

nonisolated struct SwiftDataStorageResolver {}

extension SwiftDataStorageResolver {
    nonisolated func storage(context: ModelContext, for type: SymbolType) throws -> SymbolsStorage? {
        let typeRaw = type.rawValue

        let predicate = #Predicate<SymbolsStorage> {
            $0.typeRaw == typeRaw
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
