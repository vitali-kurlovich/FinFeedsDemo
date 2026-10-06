//
//  Created by Kurlovich Vitali on 10/3/26.
//

import Observation

@Observable
final class SettingsModel {
    var service: (any TwelveDataApiKeyService)? {
        didSet {
            apiKey = service?.apiKey ?? ""
        }
    }

    var apiKey: String

    var isReady: Bool {
        service != nil
    }

    init(_ service: (any TwelveDataApiKeyService)? = nil) {
        self.service = service
        apiKey = service?.apiKey ?? ""
    }

    func save() {
        service?.update(apiKey: apiKey)
    }
}
