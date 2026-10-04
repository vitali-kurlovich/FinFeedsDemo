//
//  Created by Kurlovich Vitali on 10/4/26.
//

import Foundation

public nonisolated struct RestErrorDetails: Equatable, Sendable {
    public let httpCode: Int?
    public let description: String
}

public nonisolated enum RestError: Error, Equatable, Sendable {
    case requestError(RestErrorDetails)

    public var localizedDescription: String {
        switch self {
        case let .requestError(details):
            return details.description
        }
    }
}
