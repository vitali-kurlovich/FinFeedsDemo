//
//  Created by Kurlovich Vitali on 10/5/26.
//

import Foundation
import Observation
import SwiftData

enum PriceChange: Hashable, Sendable {
    case neutral
    case up
    case down
}

struct FeedsUpdate: Hashable, Sendable, Identifiable {
    let symbol: Symbol
    let price: Decimal?
    let timestamp: Date?
    let changes: PriceChange

    init(
        symbol: Symbol,
        price: Decimal? = nil,
        timestamp: Date? = nil,
        changes: PriceChange = .neutral
    ) {
        self.symbol = symbol
        self.price = price
        self.timestamp = timestamp
        self.changes = changes
    }

    var id: Symbol {
        symbol
    }
}

@Observable
final class SwiftDataFeedsObserver {
    private(set) var updates: [FeedsUpdate] = []

    @ObservationIgnored
    var subscribed: Set<String> = [] {
        didSet {
            if oldValue != subscribed {
                Task {
                    await invalidateSubscriptions()
                }
            }
        }
    }

    @ObservationIgnored
    private var context: ModelContext?

    @ObservationIgnored
    private var updatesMap: [Symbol: FeedsUpdate] = [:]
    @ObservationIgnored
    private var observeTask: Task<Void, Never>?
}

extension SwiftDataFeedsObserver {
    func start(context: ModelContext, subscribed: Set<String>) throws {
        self.context = context
        self.subscribed = subscribed

        observeTask = Task {
            await observe()
        }
    }

    func stop() {
        observeTask?.cancel()
        context = nil
    }
}

private extension SwiftDataFeedsObserver {
    func observe() async {
        for await notification in NotificationCenter.default.notifications(
            named: ModelContext.didSave
        ) {
            guard let context = notification.object as? ModelContext else {
                continue
            }
            do {
                let feeds = try feeds(context: context, subscribed: subscribed)
                if apply(feeds: feeds) {
                    invalidateUpdattes()
                }
            } catch {
                // TODO: Logging errors
                print(error)
            }
        }
    }
}

private extension SwiftDataFeedsObserver {
    func feeds(context: ModelContext, subscribed: Set<String>) throws -> [Feed] {
        let predicate: Predicate = #Predicate<Feed> {
            subscribed.contains($0.symbol)
        }

        let descriptor = FetchDescriptor<Feed>(predicate: predicate)

        return try context.fetch(descriptor)
    }

    nonisolated func priceChanges(old: Decimal?, new: Decimal?) -> PriceChange {
        if let old, let new {
            if new > old {
                return .up
            } else if new < old {
                return .down
            }
        }

        return .neutral
    }

    @discardableResult
    func apply(feeds: [Feed]) -> Bool {
        var changed = false
        for feed in feeds {
            let symbol = Symbol(feed.symbol)
            let price = feed.price
            let timestamp = feed.timestamp

            if let old = updatesMap[symbol] {
                if old.price != price || old.timestamp != timestamp {
                    changed = true
                    let pc = priceChanges(old: old.price, new: price)
                    updatesMap[symbol] = FeedsUpdate(symbol: symbol, price: price, timestamp: timestamp, changes: pc)
                }

            } else {
                changed = true
                updatesMap[symbol] = FeedsUpdate(
                    symbol: symbol,
                    price: price,
                    timestamp: timestamp,
                    changes: .neutral
                )
            }
        }

        return changed
    }

    func invalidateSubscriptions() async {
        let keys = updatesMap.keys

        for key in keys {
            if subscribed.contains(key.id) == false {
                updatesMap[key] = nil
            }
        }

        for name in subscribed {
            let symbol = Symbol(name)

            if updatesMap[symbol] == nil {
                updatesMap[symbol] = FeedsUpdate(symbol: symbol)
            }
        }

        guard let context else { return }

        do {
            let feeds = try feeds(context: context, subscribed: subscribed)

            apply(feeds: feeds)

            invalidateUpdattes()

        } catch {
            // TODO: Logging error
            print(error)
        }
    }

    func invalidateUpdattes() {
        let symbols = subscribed.sorted().map { Symbol($0) }
        let lastUpdates = symbols.compactMap { symbol in
            updatesMap[symbol]
        }

        if updates != lastUpdates {
            updates = lastUpdates
        }
    }
}
