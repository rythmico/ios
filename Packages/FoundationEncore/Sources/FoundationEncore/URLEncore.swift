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
        let url = try (URLComponents() => {
            $0.scheme = scheme
            $0.host = host
            $0.path = path
            $0.queryItems = queryItems
        })
        .url !! Error.invalidURLComponents
        self = doubleSlash ? url : try url.removingSchemeDoubleSlash()
    }

    private func removingSchemeDoubleSlash() throws -> URL {
        try URL(string: absoluteString.replacingOccurrences(of: "://", with: ":")) !! Error.schemeDoubleSlashRemovalFailed
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value) !! preconditionFailure("Invalid URL with string: '\(value)'")
    }
}
