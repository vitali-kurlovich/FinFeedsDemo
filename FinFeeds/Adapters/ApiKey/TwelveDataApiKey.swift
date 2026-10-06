//
//  Created by Kurlovich Vitali on 10/3/26.
//

import AsyncAlgorithms
import Foundation
import TwelveDataAdapter

private extension UserDefaults {
    private nonisolated static var key: String {
        "twelwe apiKey"
    }

    @objc dynamic nonisolated var apiKey: String {
        get {
            string(forKey: Self.key) ?? ProcessInfo.processInfo.environment["API_KEY"] ?? "" // "6cf1d9292bb94c7fab1445e06e6d901e"
        }

        set {
            setValue(newValue, forKey: Self.key)
        }
    }
}

nonisolated struct TwelveDataApiKey: TwelveDataApiKeyService, @unchecked Sendable {
    let userDefaults: UserDefaults

    let stream: any AsyncSequence<Void, Never>
    let continuation: AsyncStream<Void>.Continuation

    private let lock = NSLock()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        let (stream, continuation) = AsyncStream<Void>.makeStream(
            bufferingPolicy: .bufferingNewest(0)
        )
        self.stream = stream.share()
        self.continuation = continuation
    }

    var apiKey: String {
        lock.lock()
        defer { lock.unlock() }
        return userDefaults.apiKey
    }

    func update(apiKey: String) {
        lock.lock()
        defer { lock.unlock() }

        userDefaults.apiKey = apiKey

        continuation.yield()
    }

    var updates: any AsyncSequence<Void, Never> {
        AsyncStream<Void> { continuation in
            let task = Task {
                for await _ in stream {
                    continuation.yield()
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
