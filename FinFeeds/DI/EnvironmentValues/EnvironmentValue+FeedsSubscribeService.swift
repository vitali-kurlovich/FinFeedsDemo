//
//  Created by Kurlovich Vitali on 10/12/26.
//

import DataLayer
import SwiftUI

extension EnvironmentValues {
    @Entry var feedsSuscriberService = ServicesLocator.feedsSuscriberService
}

extension View {
    func feedsSuscriberService(_ service: any FeedsSubscribeService) -> some View {
        environment(\.feedsSuscriberService, service)
    }
}
