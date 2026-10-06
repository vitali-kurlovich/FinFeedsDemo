//
//  Created by Kurlovich Vitali on 10/2/26.
//

import DataLayer
import SwiftUI

extension EnvironmentValues {
    @Entry var connectivityService = ServicesLocator.connectivityService
}

extension View {
    func connectivityService(_ service: any ConnectivityService) -> some View {
        environment(\.connectivityService, service)
    }
}
