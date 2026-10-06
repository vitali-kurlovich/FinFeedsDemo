//
//  Created by Kurlovich Vitali on 10/3/26.
//

public nonisolated protocol TwelveDataApiKeyService: Sendable {
    var apiKey: String { get }

    func update(apiKey: String)
    func removeApiKey()

    var updates: any AsyncSequence<Void, Never> { get }
}

public extension TwelveDataApiKeyService {
    nonisolated var isReady: Bool {
        apiKey.isEmpty == false
    }

    nonisolated func removeApiKey() {
        update(apiKey: "")
    }
}
