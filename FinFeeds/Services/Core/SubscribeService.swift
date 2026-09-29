//
//  Created by Kurlovich Vitali on 9/29/26.
//

protocol SubscribeService {
    associatedtype Key: Hashable

    func subsribe(_ keys: Set<Key>)
    func unsubsribe(_ keys: Set<Key>)
}
