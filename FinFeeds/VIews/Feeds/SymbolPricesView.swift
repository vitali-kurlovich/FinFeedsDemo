//
//  Created by Kurlovich Vitali on 9/29/26.
//

import SwiftUI

extension SymbolPrice: Identifiable {
    nonisolated var id: String {
        symbol
    }
}

struct SymbolPricesView<Content: View>: View {
    @Binding
    private var prices: [SymbolPrice]

    private let content: ([SymbolPrice]) -> Content

    init(
        prices: Binding<[SymbolPrice]>,
        content: @escaping ([SymbolPrice]) -> Content
    ) {
        _prices = prices
        self.content = content
    }

    var body: some View {
        content(checkedPrices)
    }
}

extension SymbolPricesView {
    private var checkedPrices: [SymbolPrice] {
        assert(Set(prices.lazy.map { $0.id }).count == prices.count)
        return prices
    }
}
