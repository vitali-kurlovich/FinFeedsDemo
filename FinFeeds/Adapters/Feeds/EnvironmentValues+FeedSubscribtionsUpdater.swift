//
//  Created by Kurlovich Vitali on 10/13/26.
//

import SwiftData
import SwiftUI

extension FeedSubscribtionsUpdater {
    convenience init(storage: FeedSubscribtionsStorage) {
        self.init(storageReader: storage, storageWriter: storage)
    }

    convenience init(context: ModelContext?) {
        let storage = FeedSubscribtionsStorage(context: context)
        self.init(storage: storage)
    }
}

extension EnvironmentValues {
    @Entry var feedSubscribtionsUpdater = FeedSubscribtionsUpdater(context: nil)
}
