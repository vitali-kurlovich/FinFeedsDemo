//
//  Created by Kurlovich Vitali on 10/1/26.
//

import Caches
import SwiftUI

struct FeedsView: View {
    @State
    private var subscriptions: Set<String> = ["AAPL",
                                              "RY",
                                              "RY:TSX",
                                              "EUR/USD",
                                              "BTC/USD"]

    var body: some View {
        PreloadView { state in
            switch state {
            case .idle, .inProgress:
                ContentUnavailableView {
                    ProgressView {
                        Text("Loadong...")
                    }
                }

            case let .error(error):
                ContentUnavailableView {
                    Image(systemName: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                }

            case .ready:
                FeedsContentView(subscriptions: $subscriptions)
            }

        } preloadTask: {
            do {
                try await CachesLocator.pricesCache.load()
            } catch {
                // TODO: Error handeling
            }
        }
    }
}
