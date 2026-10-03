//
//  Created by Kurlovich Vitali on 10/3/26.
//

nonisolated protocol ApiKeyService: Sendable {
    var apiKey: String { get }

    func update(apiKey: String)
    func removeApiKey()

    var updates: any AsyncSequence<Void, Never> { get }
}

extension ApiKeyService {
    nonisolated var isReady: Bool {
        apiKey.isEmpty == false
    }

    nonisolated func removeApiKey() {
        update(apiKey: "")
    }
}
