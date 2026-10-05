//
//  Created by Kurlovich Vitali on 10/5/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var stockService = ServicesLocator.stockService
}

extension View {
    func cryptoService(_ service: any StocksService) -> some View {
        environment(\.stockService, service)
    }
}
