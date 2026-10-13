//
//  Created by Kurlovich Vitali on 10/1/26.
//

import DataLayer
import SwiftData
import SwiftUI

struct FeedsView: View {
    @Environment(\.priceCacheSync)
    private var cacheSync

    @Environment(\.feedSubscribtionsUpdater)
    private var feedSubscribtionsUpdater

    var body: some View {
        NavigationStack {
            SymbolFeedsPricesView()
                .task {
                    await cacheSync()
                }
        }
    }
}
