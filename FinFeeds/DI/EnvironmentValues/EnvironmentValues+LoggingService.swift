//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var loggingService = ServicesLocator.loggingService
}

extension View {
    func loggingService(_ service: any LoggingService) -> some View {
        environment(\.loggingService, service)
    }
}
