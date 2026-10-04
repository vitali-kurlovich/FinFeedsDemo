//
//  Created by Kurlovich Vitali on 10/3/26.
//

import SwiftUI

struct SymbolMenu: View {
    let symbols: Set<String>

    let disabled: Set<String>

    let insert: (String) -> Void

    init(
        symbols: Set<String> = ["AAPL", "TSLA",
                                "EUR/USD",
                                "USD/JPY",
                                "EUR/JPY",
                                "BTC/USD"],
        disabled: Set<String> = [],
        insert: @escaping (String) -> Void

    ) {
        self.symbols = symbols
        self.disabled = disabled
        self.insert = insert
    }

    var body: some View {
        Menu {
            SymbolPicker(
                symbols: symbols,
                disabled: disabled,
                action: insert
            )

        } label: {
            Label("Add Symbol", systemImage: "plus")
        }
    }
}

struct SymbolPicker: View {
    let symbols: Set<String>

    let disabled: Set<String>

    let action: (String) -> Void

    init(symbols: Set<String> = ["AAPL", "TSLA",
                                 "EUR/USD",
                                 "USD/JPY",
                                 "EUR/JPY",
                                 "BTC/USD"], disabled: Set<String> = [], action: @escaping (String) -> Void)
    {
        self.action = action
        self.symbols = symbols
        self.disabled = disabled
    }

    var body: some View {
        ForEach(ordered, id: \.self) { symbol in
            Button(symbol) {
                action(symbol)
            }.disabled(disabled.contains(symbol))
        }
    }

    private var ordered: [String] {
        symbols.sorted()
    }
}
