import SwiftUI
import TwelveData

struct ContentView: View {
    @State var messages: [TwelvedataPriceEvent] = []

    @State var state: ConnectivityView.State = .disconnected

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
            Task {
                let websocket = ServicesLocator.websocket
                await websocket.subscribe(symbols: [
                    "AAPL",
                    "RY",
                    "RY:TSX",
                    "EUR/USD",
                    "BTC/USD",
                ])
            }

        } label: {
            Text("Connect")
            ConnectivityUpdaterView()
        }
    }
}
