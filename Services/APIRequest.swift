import APIKit
import Foundation

protocol AuthorizedAPIRequest: Request {
    var accessToken: String { get }
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

protocol RythmicoAPIRequestNoResponse: RythmicoAPIRequestCore where Response == Void, DataParser == JSONRawDataParser {}

extension RythmicoAPIRequestNoResponse {
    func response(from object: DataParser.Parsed, urlResponse: HTTPURLResponse) throws -> Response { () }
    var dataParser: DataParser { JSONRawDataParser() }
}

struct RythmicoAPIError: LocalizedError, Decodable {
    var errorDescription: String?
}
