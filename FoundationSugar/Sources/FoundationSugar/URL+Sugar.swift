import Foundation

extension URL {
    public enum InitError: Error {
        case invalidURLComponents
    }

    public init(
        scheme: String,
        host: String,
        path: String = "",
        queryItems: [URLQueryItem]? = nil
    ) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            throw InitError.invalidURLComponents
        }
        self = url
    }
}
