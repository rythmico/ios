import APIKit
import FoundationEncore

/// An affordance to be able to use parameterless `coordinator.run()`
///
/// TODO: remove when moving to `APIClient`.
protocol EmptyInitProtocol {
    init()
}

protocol RythmicoAPIRequest: DecodableJSONRequest where Error == RythmicoAPIError {
    var authRequired: Bool { get }
    var headerFields: [String: String] { get set }
}

extension RythmicoAPIRequest {
    #if LIVE
    var baseURL: URL { "https://rythmico-prod.web.app/v1" }
    #else
    var baseURL: URL { "https://rythmico-api-stage.herokuapp.com" }
    #endif

    var authRequired: Bool {
        true
    }

    var decoder: Decoder {
        JSONDecoder() => (\.dateDecodingStrategy, .iso8601)
    }

    func intercept(object: Data, urlResponse: HTTPURLResponse) throws -> Data {
        guard 200..<300 ~= urlResponse.statusCode else {
            let parsedError = try? decoder.decode(Error.self, from: object)
            let error: Swift.Error = parsedError ?? NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode).capitalized(with: .current)]
            )
            // If user is not authorized...
            // TODO: do this server side, in a custom AuthMiddleware, so this whole func can be removed.
            if urlResponse.statusCode == 401 {
                throw RythmicoAPIError(description: error.legibleDescription, reason: .unauthorized)
            }
            throw error
        }
        return object
    }
}

extension JSONEncodableBodyParameters {
    init(object: E) {
        self.init(object: object, dateEncodingStrategy: .iso8601)
    }
}
