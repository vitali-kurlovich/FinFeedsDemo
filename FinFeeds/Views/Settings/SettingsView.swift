//
//  Created by Kurlovich Vitali on 10/3/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.apiKeyService)
    private var service

    @State
    var model: SettingsModel = .init()

    var body: some View {
        SettingsEditView(model: $model)
        VStack {
            Text("TwelveData API")
            if let url {
                Link("You can find API keys by link", destination: url)
            }
        }.padding()
            .onAppear {
                model.service = service
            }
    }

    var url: URL? {
        URL(string: "https://twelvedata.com/account/api-keys")
    }
}

#Preview {
    SettingsView()
}
