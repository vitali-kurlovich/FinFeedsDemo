//
//  Created by Kurlovich Vitali on 10/2/26.
//

import Logging
import LoggingBootstrapUI
import SwiftUI

struct LogsView: View {
    @State
    var logLevel: Logger.Level = .info

    var body: some View {
        VStack(alignment: .trailing) {
            LoggingHistoryView(logLevel: $logLevel) { logs in
                Table(logs) {
                    TableColumn("ID") { log in
                        Text(log.id, format: .number)
                    }
                    .width(min: 44, max: 88)
                    TableColumn("Description") { log in
                        Text(log.description)
                    }
                }
            }
            LoggerLevelPicker(logLevel: $logLevel)
        }
    }
}
