//
//  Created by Kurlovich Vitali on 9/30/26.
//

public nonisolated struct IdentifiableCollector<Element: Equatable & Identifiable>: Equatable {
    private var storage: [Element]

    public init<S: Sequence>(_ elements: S) where S.Element == Self.Element {
        assert(elements.count(where: { _ in true }) == Set(elements.map(\.id)).count)
        storage = Array(elements)
    }

    public init() {
        self.init(EmptyCollection<Element>())
    }

    public mutating func updateOrAppend(_ item: Element) -> Bool {
        if let index = storage.firstIndex(where: { item.id == $0.id }) {
            let changed = storage[index] != item
            storage[index] = item
            return changed
        } else {
            storage.append(item)
            return true
        }
    }

    public mutating func remove(by id: Element.ID) -> Bool {
        if let index = storage.firstIndex(where: { id == $0.id }) {
            storage.remove(at: index)
            return true
        }
        return false
    }

    public mutating func removeAll() {
        storage.removeAll()
    }

    public mutating func update<E: Error>(_ transform: (Element) throws(E) -> Element) throws(E) -> Bool {
        var changed = false
        for index in storage.indices {
            let new = try transform(storage[index])
            assert(storage[index].id == new.id)
            changed = changed || storage[index] != new
            storage[index] = new
        }
        return changed
    }
}

extension IdentifiableCollector: Sendable where Element: Sendable {}

extension IdentifiableCollector: Sequence {
    public typealias Iterator = Array<Element>.Iterator

    public nonisolated func makeIterator() -> Iterator {
        storage.makeIterator()
    }
}

extension IdentifiableCollector: RandomAccessCollection {
    public typealias Index = Array<Element>.Index

    public nonisolated var startIndex: Index {
        storage.startIndex
    }

    public nonisolated var endIndex: Index {
        storage.endIndex
    }

    public nonisolated subscript(position: Index) -> Element {
        storage[position]
    }
}
