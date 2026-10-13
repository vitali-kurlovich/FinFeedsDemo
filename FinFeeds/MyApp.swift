import Logging
import LoggingBootstrap
import SwiftData
import SwiftUI

@main struct MyApp: App {
    let feedSubscribtionsUpdater: FeedSubscribtionsUpdater
    let priceCacheSync: SymbolPriceCacheSync
    let feedsUpdateWatcher: FeedsUpdateWatcher

    private let container: ModelContainer
    private let context: ModelContext

    init() {
        #if DEBUG
            LoggingBootstrap.default.bootstrap(logLevel: .debug)
        #else
            LoggingBootstrap.default.bootstrap()
        #endif

        container = try! ModelContainer(for:
            .init(PersistentModels.persistentModels))

        context = ModelContext(container)

        feedSubscribtionsUpdater = FeedSubscribtionsUpdater(context: context)
        priceCacheSync = SymbolPriceCacheSync(context: context)
        feedsUpdateWatcher = FeedsUpdateWatcher(context: context)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.feedSubscribtionsUpdater, feedSubscribtionsUpdater)
                .environment(\.priceCacheSync, priceCacheSync)
                .environment(\.feedsUpdateWatcher, feedsUpdateWatcher)
        }
        .modelContext(context)
        .modelContainer(container)
        // .modelContainer(for: PersistentModels.persistentModels)
    }
}
