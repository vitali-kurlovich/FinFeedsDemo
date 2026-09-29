//
//  Created by Kurlovich Vitali on 9/29/26.
//

import SwiftUI

enum StateViewStyle {
    case compact
    case regular
}

extension EnvironmentValues {
    @Entry var stateViewStyle = StateViewStyle.compact
}

extension StateView {
    enum State: Equatable {
        case disconnected
        case connecting
        case connected
        case reconnecting
        case failed(String)
    }
}

struct StateView: View {
    let state: State

    @Environment(\.stateViewStyle)
    var stateViewStyle

    var body: some View {
        HStack {
            Image(systemName: "circle.fill")

                .foregroundStyle(color)
                .padding(1)
                .background {
                    Circle().fill(Color.white)
                }.shadow(radius: 5, y: 3)

            if stateViewStyle == .regular {
                Text(text)
            }
        }
    }
}

private extension StateView {
    var color: Color {
        switch state {
        case .disconnected:
            return .gray
        case .connecting:
            return .yellow
        case .connected:
            return .green
        case .reconnecting:
            return .yellow
        case .failed:
            return .red
        }
    }

    var text: LocalizedStringKey {
        switch state {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        case .reconnecting:
            return "Reconnecting"
        case let .failed(string):
            if string.isEmpty {
                return "Failed"
            }
            return "Failed: \(string)"
        }
    }
}

#Preview {
    HStack(spacing: 66) {
        VStack(alignment: .leading) {
            StateView(state: .disconnected)
            StateView(state: .connecting)
            StateView(state: .connected)
            StateView(state: .reconnecting)
            StateView(state: .failed(""))
            StateView(state: .failed("Error description"))
        }.environment(\.stateViewStyle, .regular)
        VStack(alignment: .leading) {
            StateView(state: .disconnected)
            StateView(state: .connecting)
            StateView(state: .connected)
            StateView(state: .reconnecting)
            StateView(state: .failed(""))
            StateView(state: .failed("Error description"))
        }.environment(\.stateViewStyle, .compact)
    }
    .frame(width: 700, height: 180)
}
