//
//  Created by Kurlovich Vitali on 10/4/26.
//

import TwelveDataREST

extension RestError {
    init(_ error: TwelveDataRESTError) {
        let details: RestErrorDetails

        switch error {
        case let .badRequest(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .unauthor­ized(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .forbidden(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .notFound(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .parameterTooLong(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .tooManyRequests(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .internalServerError(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .urlSessionError(response):
            details = .init(
                httpCode: nil,
                description: response.localizedDescription
            )
        case let .unknownServerError(response):
            details = .init(
                httpCode: response.code,
                description: response.message
            )
        case let .responseDecodingError(response):
            details = .init(
                httpCode: nil,
                description: response.localizedDescription
            )
        case .unknown:
            details = .init(
                httpCode: nil,
                description: "Unknown error"
            )
        }

        self = .requestError(details)
    }
}
