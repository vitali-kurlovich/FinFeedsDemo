import SwiftUI
import TwelveData

struct ContentView: View {
    @State var messages: [TwelvedataPriceEvent] = []

    @State var state: ConnectivityView.State = .disconnected

    var body: some View {
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

        .task(name: "messages") {
            let websocket = ServicesLocator.websocket
            Task {
                for await price in await websocket.prices {
                    messages.append(price)
                }
            }
        }
    }
}
