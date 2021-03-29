import Foundation
import Then

extension URLComponents: Then {}

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
        let url = try URLComponents()
            .with(\.scheme, scheme)
            .with(\.host, host)
            .with(\.path, path)
            .with(\.queryItems, queryItems)
            .url !! Error.invalidURLComponents
        self = doubleSlash ? url : try url.removingSchemeDoubleSlash()
    }

    private func removingSchemeDoubleSlash() throws -> URL {
        try URL(string: absoluteString.replacingOccurrences(of: "://", with: ":")) !! Error.schemeDoubleSlashRemovalFailed
    }
}
