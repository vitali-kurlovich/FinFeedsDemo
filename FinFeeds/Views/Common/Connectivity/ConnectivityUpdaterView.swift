//
//  Created by Kurlovich Vitali on 9/29/26.
//

import SwiftUI

struct ConnectivityUpdaterView: View {
    @State
    private var state: ConnectivityState = .disconnected

    @Environment(\.connectivityService)
    private var service

    var body: some View {
        ConnectivityView(state: state)
            .task {
                for await state in service.connectivity {
                    self.state = state
                }
            }
    }
}

#Preview {
    ConnectivityUpdaterView()
        .connectivityViewStyle(style: .regular)
        .frame(width: 700, height: 180)
}
