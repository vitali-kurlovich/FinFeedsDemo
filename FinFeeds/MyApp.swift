import Logging
import LoggingBootstrap
import SwiftData
import SwiftUI

@main struct MyApp: App {
    init() {
        #if DEBUG
            LoggingBootstrap.default.bootstrap(logLevel: .debug)
        #else
            LoggingBootstrap.default.bootstrap()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }.modelContainer(for: PersistentModels.persistentModels)
    }
}
