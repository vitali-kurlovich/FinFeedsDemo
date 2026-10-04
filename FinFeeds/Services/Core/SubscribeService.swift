//
//  Created by Kurlovich Vitali on 9/29/26.
//

nonisolated protocol SubscribeService: Sendable {
    associatedtype Key: Hashable & Sendable

    func subsribe(_ keys: Set<Key>)
    func unsubsribe(_ keys: Set<Key>)
}
