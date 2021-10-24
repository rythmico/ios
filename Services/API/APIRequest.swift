import APIKit
import FoundationEncore

/// An affordance to be able to use parameterless `coordinator.run()`
///
/// TODO: remove when moving to `APIClient`.
protocol EmptyInitProtocol {
    init()
}

protocol RythmicoAPIRequest: DecodableJSONRequest where Error == RythmicoAPIError {
    var headerFields: [String: String] { get set }
}

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
