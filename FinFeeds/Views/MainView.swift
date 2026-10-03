//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftUI

enum AppTab: Hashable {
    case feeds
    case logs
    case settings
}

struct MainView: View {
    @Environment(\.apiKeyService)
    var apiKeyService

    @State
    var isReady: Bool = false

    @State
    private var selectedTab: AppTab = .feeds

    var body: some View {
        TabView(selection: $selectedTab) {
            if isReady {
                Tab("Feeds", systemImage: "bag", value: .feeds) {
                    FeedsView()
                }
            }

            Tab("Logs", systemImage: "tablecells", value: .logs) {
                LogsView()
            }

            Tab("Settings", systemImage: "gear", value: .settings) {
                SettingsView()
            }.badge(isReady ? "" : "!")
        }
        .statusBar()
        .task {
            self.isReady = apiKeyService.isReady

            if isReady == false {
                selectedTab = .settings
            }

            for await _ in apiKeyService.updates {
                self.isReady = apiKeyService.isReady
            }
        }
    }
}
