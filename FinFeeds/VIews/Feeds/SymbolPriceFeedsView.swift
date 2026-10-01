//
//  Created by Kurlovich Vitali on 10/1/26.
//

import SwiftUI

struct SymbolPriceFeedsView<Content: View>: View {
    @Binding
    private var feeds: [SymbolPriceFeed]

    private let content: ([SymbolPriceFeed]) -> Content

    init(
        feeds: Binding<[SymbolPriceFeed]>,
        content: @escaping ([SymbolPriceFeed]) -> Content
    ) {
        _feeds = feeds
        self.content = content
    }

    var body: some View {
        content(checkedFeeds)
    }
}

extension SymbolPriceFeedsView {
    private var checkedFeeds: [SymbolPriceFeed] {
        assert(Set(feeds.lazy.map { $0.id }).count == feeds.count)
        return feeds
    }
}
