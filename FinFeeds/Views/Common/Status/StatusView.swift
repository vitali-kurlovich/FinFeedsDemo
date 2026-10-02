//
//  Created by Kurlovich Vitali on 10/2/26.
//

import Logging
import SwiftUI

struct StatusView: View {
    @Environment(\.loggingService)
    private var service

    @State
    var lastLogEvent: LogEvent? = nil

    var body: some View {
        HStack {
            ConnectivityUpdaterView()
                .connectivityViewStyle(style: .regular)
            Spacer()
            HStack {
                Spacer()
                LogEventView(event: lastLogEvent)
            }
        }.task {

            for await event in service.logEvents {
                lastLogEvent = event
            }
        }
    }
}

private struct LogEventView: View {
    let event: LogEvent?

    var body: some View {
        if let event {
            Text(event.message.description).lineLimit(1)
        }
    }
}
