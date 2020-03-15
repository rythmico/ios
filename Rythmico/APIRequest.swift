import APIKit

protocol AuthorizedAPIRequest: Request {
    var accessToken: String { get }
}

extension AuthorizedAPIRequest {
    var headerFields: [String : String] { ["Authorization": "Bearer " + accessToken] }
}

protocol RythmicoAPIRequest: DecodableJSONRequest, AuthorizedAPIRequest {}

extension RythmicoAPIRequest {
    #if DEBUG
    var host: String { "dev.api.rythmico.com" }
    #else
    var host: String { "api.rythmico.com" }
    #endif

    var pathPrefix: String { "/v1" }
}
