//
//  Created by Kurlovich Vitali on 10/1/26.
//

nonisolated protocol SymbolPriceFeedsService: SubscribeService, Sendable where Key == String {
    associatedtype SymbolPriceFeedsStream: AsyncSequence<[SymbolPriceFeed], Never>

    var feeds: SymbolPriceFeedsStream { get }
}
