import LoggingBootstrap
import SwiftUI

@main struct MyApp: App {
    init() {
        LoggingBootstrap.default.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
