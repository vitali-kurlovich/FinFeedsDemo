//
//  Created by Kurlovich Vitali on 10/2/26.
//

import Logging
import LoggingBootstrap

struct LoggingServiceAdapter: LoggingService {
    var logEvents: AsyncStream<LogEvent> {
        #if DEBUG
            LoggingBootstrap.default.loggingEvents(level: .debug)
        #else
            LoggingBootstrap.default.events
        #endif
    }
}
