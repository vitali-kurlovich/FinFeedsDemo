//
//  Created by Kurlovich Vitali on 10/4/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var forexService = ServicesLocator.forexService
}

extension View {
    func forexService(_ service: any ForexPairsService) -> some View {
        environment(\.forexService, service)
    }
}




