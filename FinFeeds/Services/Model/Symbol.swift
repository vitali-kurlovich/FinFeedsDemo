//
//  Created by Kurlovich Vitali on 10/3/26.
//

nonisolated struct Symbol: Hashable, Identifiable, Sendable, CustomStringConvertible, Comparable {
    let rawValue: String

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    var id: String {
        rawValue
    }

    var description: String {
        rawValue
    }

    static func < (lhs: borrowing Symbol, rhs: borrowing Symbol) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
