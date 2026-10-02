//
//  Created by Kurlovich Vitali on 10/2/26.
//

import Logging

nonisolated protocol LoggingService: Sendable {
    associatedtype LogEventsStream: AsyncSequence<LogEvent, Never>

    var logEvents: LogEventsStream { get }
}
