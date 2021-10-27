import APIKit
import FoundationEncore

/// An affordance to be able to use parameterless `coordinator.run()`
///
/// TODO: remove when moving to `APIClient`.
protocol EmptyInitProtocol {
    init()
}

protocol RythmicoAPIRequest: JSONDataRequest {
    associatedtype Body

    var authRequired: Bool { get }
    var headerFields: [String: String] { get set }
    var queryItems: [URLQueryItem] { get }
    var body: Body { get }
}

// MARK: Base URL

extension RythmicoAPIRequest {
    #if LIVE
    var baseURL: URL { "https://rythmico-prod.web.app/v1" }
    #else
    var baseURL: URL { "https://rythmico-api-stage.herokuapp.com" }
    #endif
}

// MARK: Auth

extension RythmicoAPIRequest {
    var authRequired: Bool {
        true
    }
}

// MARK: Query Items

extension RythmicoAPIRequest {
    var queryItems: [URLQueryItem] {
        []
    }

    var queryParameters: QueryParameters? {
        guard !queryItems.isEmpty else {
            return nil
        }
        return URLEncodedQueryParameters(
            parameters: queryItems.reduce(into: [String: String]()) { params, item in
                if let itemValue = item.value {
                    params[item.name] = itemValue
                }
            }
        )
    }
}

// MARK: Body

extension RythmicoAPIRequest where Body: Encodable {
    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: body, dateEncodingStrategy: .iso8601)
    }
}

extension RythmicoAPIRequest where Body == Void {
    var bodyParameters: BodyParameters? {
        nil
    }
}

// MARK: Parse Errors

extension RythmicoAPIRequest {
    func intercept(object: Data, urlResponse: HTTPURLResponse) throws -> Data {
        guard 200..<300 ~= urlResponse.statusCode else {
            let parsedError = try? JSONDecoder().decode(RythmicoAPIError.self, from: object)
            let error: Swift.Error = parsedError ?? NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode).capitalized(with: .current)]
            )
            // If user is not authorized...
            // TODO: do this server side, in a custom AuthMiddleware.
            if urlResponse.statusCode == 401 {
                throw RythmicoAPIError(description: error.legibleDescription, reason: .unauthorized)
            }
            throw error
        }
        return object
    }
}

// MARK: Parse Responses

extension RythmicoAPIRequest where Response: Decodable {
    func response(from object: DataParser.Parsed, urlResponse: HTTPURLResponse) throws -> Response {
        let decoder = JSONDecoder() => (\.dateDecodingStrategy, .iso8601)
        return try decoder.decode(Response.self, from: object)
    }
}

extension RythmicoAPIRequest where Response == Void {
    func response(from object: DataParser.Parsed, urlResponse: HTTPURLResponse) throws -> Response {
        ()
    }
}
