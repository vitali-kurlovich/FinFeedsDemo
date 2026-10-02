//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftUI

struct StatusView: View {
    var body: some View {
        HStack {
            ConnectivityUpdaterView()
                .connectivityViewStyle(style: .regular)
            Spacer()
        }
    }
}
