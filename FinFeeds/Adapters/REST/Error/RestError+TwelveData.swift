//
//  Created by Kurlovich Vitali on 10/4/26.
//

import TwelveDataREST

extension FetchError {
    init(_ error: TwelveDataRESTError) {
        let details: FetchErrorDescription

        switch error {
        case let .badRequest(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .unauthor­ized(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .forbidden(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .notFound(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .parameterTooLong(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .tooManyRequests(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .internalServerError(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .urlSessionError(response):
            details = .init(
                code: nil,
                description: response.localizedDescription
            )
        case let .unknownServerError(response):
            details = .init(
                code: response.code,
                description: response.message
            )
        case let .responseDecodingError(response):
            details = .init(
                code: nil,
                description: response.localizedDescription
            )
        case .unknown:
            details = .init(
                code: nil,
                description: "Unknown error"
            )
        }

        self = .requestError(details)
    }
}
