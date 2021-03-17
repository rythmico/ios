import Foundation

extension URL {
    public enum Error: Swift.Error {
        case invalidURLComponents
        case schemeDoubleSlashRemovalFailed
    }

    public init(
        scheme: String,
        doubleSlash: Bool = true,
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
            throw Error.invalidURLComponents
        }
        self = try doubleSlash ? url : url.removingSchemeDoubleSlash()
    }

    private func removingSchemeDoubleSlash() throws -> URL {
        guard let url = URL(string: absoluteString.replacingOccurrences(of: "://", with: ":")) else {
            throw Error.schemeDoubleSlashRemovalFailed
        }
        return url
    }
}
