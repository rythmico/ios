extension URL {
    public enum Error: LocalizedError {
        case invalidURLComponents(URLComponents)
        case schemeDoubleSlashRemovalFailed(URL)

        public var errorDescription: String? {
            switch self {
            case .invalidURLComponents(let urlComponents):
                return "Failed to initialize URL with components: \(urlComponents)"
            case .schemeDoubleSlashRemovalFailed(let url):
                return "Failed to remove double slash from URL: \(url)"
            }
        }
    }

    public init(
        scheme: String,
        doubleSlash: Bool = true,
        host: String,
        path: String = "",
        queryItems: [URLQueryItem]? = nil
    ) throws {
        let urlComponents = URLComponents() => {
            $0.scheme = scheme
            $0.host = host
            $0.path = path
            $0.queryItems = queryItems
        }
        let url = try urlComponents.url !! Error.invalidURLComponents(urlComponents)
        self = doubleSlash ? url : try url.removingSchemeDoubleSlash()
    }

    private func removingSchemeDoubleSlash() throws -> URL {
        try URL(string: absoluteString.replacingOccurrences(of: "://", with: ":")) !! Error.schemeDoubleSlashRemovalFailed(self)
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value) !! preconditionFailure("Invalid URL with string: '\(value)'")
    }
}
