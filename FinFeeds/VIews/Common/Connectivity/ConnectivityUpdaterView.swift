//
//  Created by Kurlovich Vitali on 9/29/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var connectivityService = ServicesLocator.connectivityService
}

extension View {
    func connectivityService(_ service: any ConnectivityService) -> some View {
        environment(\.connectivityService, service)
    }
}

struct ConnectivityUpdaterView: View {
    @State
    private var state: ConnectivityState = .disconnected

    @Environment(\.connectivityService)
    var service

    var body: some View {
        ConnectivityView(state: state)
            .task(name: "Connectivity") {
                Task {

                    for await state in service.connectivity {
                        self.state = state
                    }
                }
            }
    }
}

#Preview {
    ConnectivityUpdaterView()
        .connectivityViewStyle(style: .regular)
        .frame(width: 700, height: 180)
}
