import APIKit
import FoundationEncore

/// An affordance to be able to use parameterless `coordinator.run()`
///
/// TODO: remove when moving to `APIClient`.
protocol EmptyInitProtocol {
    init()
}

/// Defines a Rythmico API request.
protocol APIRequest: JSONDataRequest {
    associatedtype Body

    var authRequired: Bool { get }
    var headerFields: [String: String] { get set }
    var queryItems: [URLQueryItem] { get }
    var body: Body { get }
}

// MARK: Base URL

extension APIRequest {
    var baseURL: URL { APIUtils.url(path: "") }
}

// MARK: Auth

extension APIRequest {
    var authRequired: Bool {
        true
    }
}

// MARK: Query Items

extension APIRequest {
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

extension APIRequest where Body: Encodable {
    var bodyParameters: BodyParameters? {
        let encoder = JSONEncoder() => {
            $0.dateEncodingStrategy = .iso8601
        }
        return JSONEncodableBodyParameters(object: body, encoder: encoder)
    }
}

extension APIRequest where Body == Void {
    var bodyParameters: BodyParameters? {
        nil
    }
}

// MARK: Parse Errors

extension APIRequest {
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
                throw RythmicoAPIError(description: error.legibleDescription, reason: .known(.unauthorized))
            }
            throw error
        }
        return object
    }
}

// MARK: Parse Responses

extension APIRequest where Response: Decodable {
    func response(from object: DataParser.Parsed, urlResponse: HTTPURLResponse) throws -> Response {
        let decoder = JSONDecoder() => {
            $0.dateDecodingStrategy = .iso8601
        }
        return try decoder.decode(Response.self, from: object)
    }
}

extension APIRequest where Response == Void {
    func response(from object: DataParser.Parsed, urlResponse: HTTPURLResponse) throws -> Response {
        ()
    }
}
