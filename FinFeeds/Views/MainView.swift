//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Feeds", systemImage: "bag") {
                FeedsView()
            }

            Tab("Logs", systemImage: "tablecells") {
                LogsView()
            }
        }.statusBar()
    }
}
