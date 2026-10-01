//
//  Created by Kurlovich Vitali on 9/30/26.
//

@testable import FinFeeds
import Foundation
import Testing

struct MocElement: Equatable, Identifiable {
    let id: Int
    let value: String
}

struct IdentifiableCollectorTests {
    @Test
    func initialize() {
        let empty = IdentifiableCollector<MocElement>()
        #expect(empty.isEmpty)

        let collection = (0 ..< 5).lazy.map { MocElement(id: $0, value: .init($0)) }

        let collector = IdentifiableCollector(collection)
        #expect(collector.count == 5)

        #expect(collector[0] == .init(id: 0, value: "0"))
        #expect(collector[1] == .init(id: 1, value: "1"))
        #expect(collector[2] == .init(id: 2, value: "2"))
        #expect(collector[3] == .init(id: 3, value: "3"))
        #expect(collector[4] == .init(id: 4, value: "4"))
    }

    @Test
    func updateOrAppend() {
        var collector = IdentifiableCollector<MocElement>()

        #expect(collector.updateOrAppend(.init(id: 1, value: "1")) == true)
        #expect([MocElement(id: 1, value: "1")] == Array(collector))

        #expect(collector.updateOrAppend(.init(id: 1, value: "1")) == false)
        #expect([MocElement(id: 1, value: "1")] == Array(collector))

        #expect(collector.updateOrAppend(.init(id: 1, value: "2")) == true)
        #expect([MocElement(id: 1, value: "2")] == Array(collector))

        #expect(collector.updateOrAppend(.init(id: 2, value: "2")) == true)
        #expect([MocElement(id: 1, value: "2"), MocElement(id: 2, value: "2")] == Array(collector))
    }

    @Test
    func remove() {
        var collector = IdentifiableCollector([
            MocElement(id: 1, value: "1"),
            MocElement(id: 2, value: "2"),
            MocElement(id: 3, value: "3"),
        ])

        #expect([
            MocElement(id: 1, value: "1"),
            MocElement(id: 2, value: "2"),
            MocElement(id: 3, value: "3"),
        ] == Array(collector))

        #expect(collector.remove(by: 0) == false)

        #expect([
            MocElement(id: 1, value: "1"),
            MocElement(id: 2, value: "2"),
            MocElement(id: 3, value: "3"),
        ] == Array(collector))

        #expect(collector.remove(by: 1) == true)

        #expect([
            MocElement(id: 2, value: "2"),
            MocElement(id: 3, value: "3"),
        ] == Array(collector))

        #expect(collector.remove(by: 1) == false)

        #expect([
            MocElement(id: 2, value: "2"),
            MocElement(id: 3, value: "3"),
        ] == Array(collector))

        collector.removeAll()
        #expect(collector.isEmpty)
    }

    @Test
    func update() {
        var collector = IdentifiableCollector([
            MocElement(id: 1, value: "1"),
            MocElement(id: 2, value: "2"),
            MocElement(id: 3, value: "3"),
        ])

        #expect(collector.update { $0 } == false)

        #expect(collector == IdentifiableCollector([
            MocElement(id: 1, value: "1"),
            MocElement(id: 2, value: "2"),
            MocElement(id: 3, value: "3"),
        ]))

        #expect(
            collector
                .update { MocElement(id: $0.id, value: "-\($0.value)")
                } == true
        )

        #expect(collector == IdentifiableCollector([
            MocElement(id: 1, value: "-1"),
            MocElement(id: 2, value: "-2"),
            MocElement(id: 3, value: "-3"),
        ]))
    }
}
