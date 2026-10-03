//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftUI

struct SettingsEditView: View {
    @Binding
    var model: SettingsModel

    var body: some View {
        VStack(alignment: .trailing) {
            TextField("API Key", text: $model.apiKey)

            Button("Save") {
                model.save()
            }.disabled(!model.isApiKeyChanged)
        }.padding()
            .disabled(!model.isReady)
    }
}

#Preview {
    @Previewable @State
    var model = SettingsModel() // ServicesLocator.apiKeyService)

    SettingsEditView(model: $model)
        .frame(width: 400, height: 340)
}
