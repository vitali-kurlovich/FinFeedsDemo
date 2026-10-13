//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import DataLayer
import Foundation
import SwiftData

enum FeedSubscribtionsStorageError: Error {
    case readError(String)
    case writeError(String)

    var localizedDescription: String {
        switch self {
        case let .readError(description):
            return description
        case let .writeError(description):
            return description
        }
    }
}

struct FeedSubscribtionsStorage: Sendable {
    let context: ModelContext?
}

extension FeedSubscribtionsStorage: ValueStorageReader<Set<Symbol>, FeedSubscribtionsStorageError> {
    func readValue() async throws(FeedSubscribtionsStorageError) -> Set<Symbol>? {
        guard let context else {
            assertionFailure("Requare context")
            return []
        }

        var descriptor = FetchDescriptor<FeedsSubscriptions>()
        descriptor.fetchLimit = 1
        do {
            guard let storage = try context.fetch(descriptor).first else {
                return []
            }

            return Set(storage.subscriptions.lazy.map { Symbol($0) })

        } catch {
            throw .readError(error.localizedDescription)
        }
    }
}

extension FeedSubscribtionsStorage: ValueStorageWriter<Set<Symbol>, FeedSubscribtionsStorageError> {
    func write(value: Set<Symbol>?) async throws(
        FeedSubscribtionsStorageError
    ) {
        guard let context else {
            assertionFailure("Requare context")
            return
        }

        var descriptor = FetchDescriptor<FeedsSubscriptions>()
        descriptor.fetchLimit = 1

        do {
            let subscriptions = Set(value?.lazy.map { $0.rawValue } ?? [])

            if let storage = try context.fetch(descriptor).first {
                storage.subscriptions = subscriptions
            } else {
                let storage = FeedsSubscriptions(subscriptions: subscriptions)
                context.insert(storage)
            }

        } catch {
            throw .readError(error.localizedDescription)
        }

        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            throw .writeError(error.localizedDescription)
        }
    }
}
