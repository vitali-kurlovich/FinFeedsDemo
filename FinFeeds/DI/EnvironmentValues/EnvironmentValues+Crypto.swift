//
//  Created by Kurlovich Vitali on 10/5/26.
//

import DataLayer
import SwiftUI

extension EnvironmentValues {
    @Entry var cryptoService = ServicesLocator.cryptoService
}

extension View {
    func cryptoService(_ service: any CryptoPairsService) -> some View {
        environment(\.cryptoService, service)
    }
}
