//
//  Created by Kurlovich Vitali on 9/29/26.
//

protocol KeyValueStorage {
    associatedtype Key: Hashable
    associatedtype Value

    func value(for key: Key) -> Value?
}

protocol MutableKeyValueStorage: KeyValueStorage {
    func set(value: Value?, for key: Key)
}
