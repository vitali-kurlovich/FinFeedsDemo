//
//  Created by Kurlovich Vitali on 10/2/26.
//

import SwiftData
import SwiftUI
import TwelveDataAdapter

enum AppTab: Hashable {
    case feeds
    case logs
    case settings
}

struct MainView: View {
    @Environment(\.apiKeyService)
    private var apiKeyService

    @Environment(\.symbolPriceService)
    private var symbolPriceService

    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.swiftDataSymbolPriceCoordinator)
    private var priceRepository

    @State
    private var isReady: Bool = false

    @State
    private var selectedTab: AppTab = .feeds

    var body: some View {
        TabView(selection: $selectedTab) {
            #if os(macOS)
                if isReady {
                    Tab("Feeds", systemImage: "bag", value: .feeds) {
                        FeedsView()
                    }
                }
            #else
                Tab("Feeds", systemImage: "bag", value: .feeds) {
                    FeedsView()
                }.disabled(isReady == false)
            #endif

            Tab("Logs", systemImage: "tablecells", value: .logs) {
                LogsView()
            }

            Tab("Settings", systemImage: "gear", value: .settings) {
                SettingsView()
            }.badge(isReady ? nil : Text("!"))
        }
        .statusBar()
        .onAppear {
            priceRepository
                .start(service: symbolPriceService, context: modelContext)
        }
        .onDisappear {
            priceRepository.stop()
        }

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

// SwiftDataymbolPriceRepository(context: modelContext, service: symbolPriceService)
