//
//  Created by Kurlovich Vitali on 10/1/26.
//

import SwiftUI

enum PreloadState {
    case idle
    case inProgress
    case ready
    case error(any Error)
}

struct PreloadView<Content: View>: View {
    @State
    private var state: PreloadState = .idle

    let content: (PreloadState) -> Content
    let preloadTask: () async throws -> Void

    var body: some View {
        content(state)
            .task {
                state = .inProgress
                do {
                    try await preloadTask()

                    state = .ready
                } catch {
                    state = .error(error)
                }
            }
    }
}
