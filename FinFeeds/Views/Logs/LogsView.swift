//
//  LogsView.swift
//  FinFeeds
//
//  Created by Kurlovich Vitali on 10/2/26.
//

import LoggingBootstrapUI
import SwiftUI

struct LogsView: View {
    var body: some View {
        LoggingHistoryView { logs in
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
    }
}
