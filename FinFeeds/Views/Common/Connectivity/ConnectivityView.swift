//
//  Created by Kurlovich Vitali on 9/29/26.
//

import DataLayer
import SwiftUI

enum ConnectivityViewStyle {
    case compact
    case regular
}

extension ConnectivityView {
    typealias State = ConnectivityState
}

struct ConnectivityView: View {
    let state: State

    @Environment(\.connectivityViewStyle)
    var connectivityViewStyle

    var body: some View {
        HStack {
            Image(systemName: "circle.fill")

                .foregroundStyle(color)
                .padding(1)
                .background {
                    Circle().fill(Color.white)
                }.shadow(radius: 5, y: 3)

            if connectivityViewStyle == .regular {
                Text(text)
            }
        }
    }
}

private extension ConnectivityView {
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

extension EnvironmentValues {
    @Entry var connectivityViewStyle = ConnectivityViewStyle.compact
}

extension View {
    func connectivityViewStyle(style: ConnectivityViewStyle) -> some View {
        environment(\.connectivityViewStyle, style)
    }
}

#Preview {
    HStack(spacing: 66) {
        VStack(alignment: .leading) {
            ConnectivityView(state: .disconnected)
            ConnectivityView(state: .connecting)
            ConnectivityView(state: .connected)
            ConnectivityView(state: .reconnecting)
            ConnectivityView(state: .failed(""))
            ConnectivityView(state: .failed("Error description"))
        }
        .connectivityViewStyle(style: .regular)
        VStack(alignment: .leading) {
            ConnectivityView(state: .disconnected)
            ConnectivityView(state: .connecting)
            ConnectivityView(state: .connected)
            ConnectivityView(state: .reconnecting)
            ConnectivityView(state: .failed(""))
            ConnectivityView(state: .failed("Error description"))
        }
        .connectivityViewStyle(style: .compact)
    }
    .frame(width: 700, height: 180)
}
