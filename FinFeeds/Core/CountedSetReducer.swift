//
//  Created by Kurlovich Vitali on 9/29/26.
//

import Foundation

struct CountedSetReducer<Value: Hashable> {
    let countedSet = NSCountedSet()

    func insert(_ set: Set<Value>) -> Set<Value> {
        var reduced = Set<Value>()
        reduced.reserveCapacity(set.count)

        for value in set {
            countedSet.add(value)

            if countedSet.count(for: value) == 1 {
                reduced.insert(value)
            }
        }

        return reduced
    }

    func remove(_ set: Set<Value>) -> Set<Value> {
        var reduced = Set<Value>()
        reduced.reserveCapacity(set.count)

        for value in set {
            countedSet.remove(value)

            if countedSet.contains(value) == false {
                reduced.insert(value)
            }
        }

        return reduced
    }
}
