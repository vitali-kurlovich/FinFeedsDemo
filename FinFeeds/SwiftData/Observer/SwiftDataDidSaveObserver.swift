//
//  Created by Kurlovich Vitali on 10/13/26.
//

import Foundation
import SwiftData

struct SwiftDataDidSaveObserver {
    var updates: AsyncStream<Void> {
        AsyncStream<Void> { continuation in
            let task = Task {
                for await notification in NotificationCenter.default.notifications(
                    named: ModelContext.didSave
                ) {
                    guard let _ = notification.object as? ModelContext else {
                        continue
                    }
                    continuation.yield()
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
