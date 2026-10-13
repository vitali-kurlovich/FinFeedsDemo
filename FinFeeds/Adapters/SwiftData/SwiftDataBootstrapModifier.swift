//
//  Created by Kurlovich Vitali on 10/13/26.
//

import SwiftUI

extension View {
    func swiftDataBootstrap() -> some View {
        modifier(SwiftDataBootstrapModifier())
    }
}

struct SwiftDataBootstrapModifier: ViewModifier {
    @Environment(\.feedSubscribtionsUpdater)
    private var feedSubscribtionsUpdater

    func body(content: Content) -> some View {
        content
            .task(name: "SwiftDataDidSaveObserver") {
                let observer = SwiftDataDidSaveObserver()

                for await _ in observer.updates {
                    do {
                        try await feedSubscribtionsUpdater.prefetch()
                    } catch {
                        //  TODO: Logging error
                    }
                }
            }
    }
}
