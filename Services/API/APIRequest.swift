import APIKit
import Foundation

@dynamicMemberLookup
protocol AuthorizedAPIRequest: Request {
    associatedtype Properties

    var accessToken: String { get }
    var properties: Properties { get }

    init(accessToken: String, properties: Properties) throws
}

extension AuthorizedAPIRequest {
    var headerFields: [String: String] {
        [
            "Authorization": "Bearer " + accessToken,
            "User-Agent": APIUserAgent.current ?? "Unknown",
        ]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Properties, T>) -> T {
        properties[keyPath: keyPath]
    }
}

protocol RythmicoAPIRequest: AuthorizedAPIRequest, DecodableJSONRequest {}

extension RythmicoAPIRequest {
    #if DEBUG
    var host: String { "rythmico-dev.web.app" }
    #else
    var host: String { "rythmico-prod.web.app" }
    #endif

    var pathPrefix: String { "/v1" }

    var decoder: Decoder {
        JSONDecoder().with(\.dateDecodingStrategy, .secondsSince1970)
    }
}

extension JSONEncodableBodyParameters {
    init(object: E) {
        self.init(object: object, dateEncodingStrategy: .secondsSince1970)
    }
}

struct RythmicoAPIError: LocalizedError, Decodable {
    enum ErrorType: String, Decodable {
        case appOutdated = "APP_OUTDATED"
        case unknown

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = Self(rawValue: rawValue) ?? .unknown
        }
    }
    var errorType: ErrorType?
    var errorDescription: String?
}
