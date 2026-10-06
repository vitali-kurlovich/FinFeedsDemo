//
//  Created by Kurlovich Vitali on 10/3/26.
//

import SwiftUI
import TwelveDataAdapter

extension EnvironmentValues {
    @Entry var apiKeyService = ServicesLocator.apiKeyService
}

extension View {
    func apiKeyService(_ service: any TwelveDataApiKeyService) -> some View {
        environment(\.apiKeyService, service)
    }
}
