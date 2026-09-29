//
//  Created by Kurlovich Vitali on 9/29/26.
//

/// Sequence+Sort
extension Sequence {
    /// Sorts a sequence based on a Comparable property extracted via a KeyPath.
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, descending: Bool = false) -> [Element] {
        sorted { a, b in
            if descending {
                return a[keyPath: keyPath] > b[keyPath: keyPath]
            } else {
                return a[keyPath: keyPath] < b[keyPath: keyPath]
            }
        }
    }
}
