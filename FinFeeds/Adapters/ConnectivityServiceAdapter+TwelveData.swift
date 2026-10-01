//
//  Created by Kurlovich Vitali on 9/29/26.
//

import TwelveData

struct TwelveDataConnectivityAdapter: ConnectivityService, Sendable {
    let socket: TwelveDataWebsocket

    var connectivity: AsyncStream<ConnectivityState> {
        return AsyncStream<ConnectivityState> { continuation in
            let task = Task {

                let stream = await socket.state

                for await state in stream {
                    let state = ConnectivityState(state)
                    continuation.yield(state)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

extension ConnectivityState {
    nonisolated init(_ state: TwelveDataWebsocket.State) {
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
