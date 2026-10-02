//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var symbolPriceFeedsService = ServicesLocator.symbolPriceFeedsService
}

extension View {
    func symbolPriceFeedsService(_ service: any SymbolPriceFeedsService) -> some View {
        environment(\.symbolPriceFeedsService, service)
    }
}
