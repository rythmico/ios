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
        JSONDecoder().then { $0.dateDecodingStrategy = .millisecondsSince1970 }
    }
}

struct RythmicoAPIError: LocalizedError, Decodable {
    var errorDescription: String?
}
