import SwiftUI
import TwelveData

struct ContentView: View {
    @Environment(\.symbolPriceService)
    private var service

    var body: some View {
        SymbolPricesUpdaterView { prices in
            Table(prices) {
                TableColumn("Symbol") { price in
                    Text(price.symbol)
                }
                .width(min: 44, max: 88)
                TableColumn("Price") { price in
                    Text(price.price, format: .number)
                }
            }
        }

        Button {
            service.subsribe([
                "AAPL",
                "RY",
                "RY:TSX",
                "EUR/USD",
                "BTC/USD",
            ])

        } label: {
            Text("Connect")
            ConnectivityUpdaterView()
        }
    }
}
