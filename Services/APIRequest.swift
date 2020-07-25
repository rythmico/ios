import APIKit
import Foundation

@dynamicMemberLookup
protocol AuthorizedAPIRequest: Request {
    associatedtype Properties

    var accessToken: String { get }
    var properties: Properties { get }

    init(accessToken: String, properties: Properties) throws
}

extension AuthorizedAPIRequest where Properties == Void {
    init(accessToken: String) throws {
        try self.init(accessToken: accessToken, properties: ())
    }
}

extension AuthorizedAPIRequest {
    subscript<T>(dynamicMember keyPath: KeyPath<Properties, T>) -> T {
        properties[keyPath: keyPath]
    }
}

extension AuthorizedAPIRequest {
    var headerFields: [String: String] {
        [
            "Authorization": "Bearer " + accessToken,
            "User-Agent": APIUserAgent.current ?? "Unknown",
        ]
    }
}

protocol RythmicoAPIRequestCore: AuthorizedAPIRequest {}

extension RythmicoAPIRequestCore {
    #if DEBUG
    var host: String { "rythmico-dev.web.app" }
    #else
    var host: String { "rythmico-prod.web.app" }
    #endif

    var pathPrefix: String { "/v1" }
}

protocol RythmicoAPIRequest: RythmicoAPIRequestCore, DecodableJSONRequest {}

extension RythmicoAPIRequest {
    var decoder: Decoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }
}

protocol RythmicoAPIRequestNoResponse: RythmicoAPIRequestCore where Response == Void, DataParser == JSONRawDataParser {}

extension RythmicoAPIRequestNoResponse {
    func response(from object: DataParser.Parsed, urlResponse: HTTPURLResponse) throws -> Response { () }
    var dataParser: DataParser { JSONRawDataParser() }
}

struct RythmicoAPIError: LocalizedError, Decodable {
    var errorDescription: String?
}
