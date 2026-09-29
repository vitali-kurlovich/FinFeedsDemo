//
//  Created by Kurlovich Vitali on 9/29/26.
//

protocol SymbolPriceService: SubscribeService where Key == String {
    associatedtype SymbolPriceStream: AsyncSequence<SymbolPrice, Never>

    var symbolPriceStream: SymbolPriceStream { get }
}
