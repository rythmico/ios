import APIKit
import FoundationSugar

@dynamicMemberLookup
protocol AuthorizedAPIRequest: Request {
    associatedtype Properties

    var accessToken: String { get }
    var properties: Properties { get }

    init(accessToken: String, properties: Properties) throws
}

extension AuthorizedAPIRequest {
    var headerFields: [String: String] {
        APIClientInfo.current + [
            "Authorization": "Bearer " + accessToken,
            "Accept-Encoding": "",
        ]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Properties, T>) -> T {
        properties[keyPath: keyPath]
    }
}

protocol RythmicoAPIRequest: AuthorizedAPIRequest, DecodableJSONRequest {}

extension RythmicoAPIRequest {
    #if DEBUG
    var baseURL: URL { "https://rythmico-dev.web.app/v1" }
    #else
    var baseURL: URL { "https://rythmico-prod.web.app/v1" }
    #endif

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
    var errorType: ErrorType?
    var errorDescription: String?
}

extension RythmicoAPIError.ErrorType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Self(rawValue: rawValue) ?? .unknown
    }
}
