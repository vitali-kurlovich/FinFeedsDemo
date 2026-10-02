//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftUI

extension View {
    func statusBar() -> some View {
        modifier(StatusBarModifier())
    }
}

struct StatusBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content.frame(width: .infinity, height: .infinity)
            StatusView().frame(width: .infinity)
        }.padding()
    }
}
