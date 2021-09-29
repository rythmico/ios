import APIKit
import CoreDTOEncore

@dynamicMemberLookup
protocol AuthorizedAPIRequest: Request {
    associatedtype Properties

    var accessToken: String { get }
    var properties: Properties { get }

    init(accessToken: String, properties: Properties) throws
}

extension AuthorizedAPIRequest {
    var headerFields: [String: String] {
        let clientInfo = APIClientInfo.current !! preconditionFailure("Required client info is unavailable")
        let clientInfoHeaders = clientInfo.encodeAsHTTPHeaders()
        return clientInfoHeaders + ["Authorization": "Bearer " + accessToken]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Properties, T>) -> T {
        properties[keyPath: keyPath]
    }
}

protocol RythmicoAPIRequest: AuthorizedAPIRequest, DecodableJSONRequest {}

extension RythmicoAPIRequest {
    #if LIVE
    var baseURL: URL { "https://rythmico-prod.web.app/v1" }
    #else
    var baseURL: URL { "https://rythmico-dev.web.app/v1" }
    #endif

    var decoder: Decoder {
        JSONDecoder() => (\.dateDecodingStrategy, .secondsSince1970)
    }
}

extension JSONEncodableBodyParameters {
    init(object: E) {
        self.init(object: object, dateEncodingStrategy: .secondsSince1970)
    }
}
