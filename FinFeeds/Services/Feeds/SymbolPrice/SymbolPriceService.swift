//
//  Created by Kurlovich Vitali on 9/29/26.
//

protocol SymbolPriceService {
    associatedtype SymbolPriceStream: AsyncSequence<SymbolPrice, Never>

    var symbolPriceStream: SymbolPriceStream { get }

    func subsribe(symbols: Set<String>)
    func unsubsribe(symbols: Set<String>)
}
