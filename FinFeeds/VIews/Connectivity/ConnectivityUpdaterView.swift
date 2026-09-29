//
//  Created by Kurlovich Vitali on 9/29/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var connectivityService: any ConnectivityService? = nil
}

extension View {
    func connectivityService(_ service: any ConnectivityService?) -> some View {
        environment(\.connectivityService, service)
    }
}

struct ConnectivityUpdaterView: View {
    @State
    private var state: ConnectivityState = .disconnected

    @Environment(\.connectivityService)
    var connectivityService

    var body: some View {
        ConnectivityView(state: state)
            .task(name: "connectivity") {
                guard let connectivity = connectivityService?.connectivity else {
                    state =
                        .failed(
                            "Can't find \(String(describing: (any ConnectivityService).self))"
                        )
                    return
                }

                Task {
                    for await state in connectivity {
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
