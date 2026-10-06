//
//  Created by Kurlovich Vitali on 10/2/26.
//

import DataLayer
import SwiftUI

extension EnvironmentValues {
    @Entry var symbolPriceService = ServicesLocator.symbolPriceService
}

extension View {
    func symbolPriceService(_ service: any SymbolPriceService) -> some View {
        environment(\.symbolPriceService, service)
    }
}
