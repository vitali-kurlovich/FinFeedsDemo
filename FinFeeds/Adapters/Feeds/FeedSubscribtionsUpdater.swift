//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import DataLayer
import Observation

@Observable
final class FeedSubscribtionsUpdater {
    let storageReader: any ValueStorageReader<Set<Symbol>, FeedSubscribtionsStorageError> & Sendable
    let storageWriter: any ValueStorageWriter<Set<Symbol>, FeedSubscribtionsStorageError> & Sendable

    var subscriptions: [Symbol] {
        return _subscriptions
    }

    private var _subscriptions: [Symbol] = []

    init(
        storageReader: any ValueStorageReader<Set<Symbol>, FeedSubscribtionsStorageError> & Sendable,
        storageWriter: any ValueStorageWriter<Set<Symbol>, FeedSubscribtionsStorageError> & Sendable
    ) {
        self.storageReader = storageReader
        self.storageWriter = storageWriter
    }

    func prefetch() async throws {
        let subscriptions = try (await storageReader.readValue() ?? []).sorted(by: \.id)
        if _subscriptions != subscriptions {
            _subscriptions = subscriptions
        }
    }

    func update(subscriptions: Set<Symbol>) async throws {
        try await storageWriter.write(value: subscriptions)
        try await prefetch()
    }

    func insert(subscriptions: Set<Symbol>) async throws {
        var current = try await storageReader.readValue() ?? []
        current.formUnion(subscriptions)

        try await update(subscriptions: current)
    }

    func remove(subscriptions: Set<Symbol>) async throws {
        var current = try await storageReader.readValue() ?? []

        current.subtract(subscriptions)

        try await update(subscriptions: current)
    }
}
