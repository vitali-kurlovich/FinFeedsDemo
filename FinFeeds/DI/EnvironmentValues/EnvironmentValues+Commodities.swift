//
//  Created by Kurlovich Vitali on 10/5/26.
//

import SwiftUI


extension EnvironmentValues {
    @Entry var commoditiesService = ServicesLocator.commoditiesService
}

extension View {
    func commoditiesService(_ service: any CommoditiesPairsService) -> some View {
        environment(\.commoditiesService, service)
    }
}
