//
//  Created by Kurlovich Vitali on 9/29/26.
//

protocol ConnectivityService {
    associatedtype Connectivity: AsyncSequence<ConnectivityState, Never>

    var connectivity: Connectivity { get }
}
