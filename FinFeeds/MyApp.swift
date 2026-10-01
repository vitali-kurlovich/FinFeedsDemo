import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .connectivityService(ServicesLocator.connectivityService)
                .symbolPriceService(ServicesLocator.symbolPriceService)
                .symbolPriceFeedsService(
                    ServicesLocator.symbolPriceFeedsService
                )
        }
    }
}
