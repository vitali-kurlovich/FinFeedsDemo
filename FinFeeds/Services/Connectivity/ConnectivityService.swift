//
//  Created by Kurlovich Vitali on 9/29/26.
//

nonisolated protocol ConnectivityService: Sendable {
    associatedtype Connectivity: AsyncSequence<ConnectivityState, Never>

    var connectivityLastState: ConnectivityState { get async }
    var connectivity: Connectivity { get }
}
