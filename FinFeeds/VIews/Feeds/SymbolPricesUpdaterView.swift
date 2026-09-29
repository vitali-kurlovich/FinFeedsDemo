//
//  Created by Kurlovich Vitali on 9/29/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var symbolPriceService: any SymbolPriceService? = nil
}

extension View {
    func symbolPriceService(_ service: any SymbolPriceService?) -> some View {
        environment(\.symbolPriceService, service)
    }
}

enum SymbolPriceOrder: Equatable, Sendable {
    case symbol
    case date
}

struct SymbolPricesUpdaterView<Content: View>: View {
    @Environment(\.symbolPriceService)
    var symbolPriceService

    @State
    private var prices: [SymbolPrice] = []

    @State
    private var order: SymbolPriceOrder = .symbol

    private let content: ([SymbolPrice]) -> Content

    init(
        content: @escaping ([SymbolPrice]) -> Content
    ) {
        self.content = content
    }

    var body: some View {
        SymbolPricesView(prices: $prices, content: content)
            .task {
                guard let stream = symbolPriceService?.symbolPriceStream else {
                    // TODO: Error state
                    return
                }

                Task {
                    for await price in stream {
                        if let index = prices.firstIndex(where: { price.symbol == $0.symbol }) {
                            prices[index] = price
                        } else {
                            prices.append(price)
                        }
                    }
                }
            }
    }
}

private extension SymbolPricesUpdaterView {
    var orderedPrices: [SymbolPrice] {
        switch order {
        case .symbol:
            prices.sorted(by: \.symbol)
        case .date:
            prices.sorted(by: \.timestamp)
        }
    }
}
