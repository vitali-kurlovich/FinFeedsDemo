import SwiftUI
import TwelveData


extension StateView.State {
    init(_ state: TwelveDataWebsocket.State) {
        switch state {
        case .disconnected:
            self = .disconnected
        case .connecting:
            self = .connecting
        case .connected:
            self = .connected
        case .reconnecting:
            self = .reconnecting
        case .failed:
            self = .failed("")
        }
    }
}

struct ContentView: View {
    @State var messages: [TwelvedataPriceEvent] = []

    @State var state: StateView.State = .disconnected

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
            StateView(state: state).font(.caption)
        }

        .task(name: "messages") {
            let websocket = ServicesLocator.websocket
            Task {
                for await price in await websocket.prices {
                    messages.append(price)
                    print(price)
                }
            }
        }.task(name: "state") {
            let websocket = ServicesLocator.websocket
            Task {
                for await state in await websocket.state {
                    self.state = .init(state)
                }
            }
        }
    }
}
