extension BundleProtocol {
    public var clientInfo: APIClientInfo? {
        guard
            let id = id,
            let version = version,
            let build = build
        else {
            return nil
        }
        return APIClientInfo(
            id: id.rawValue,
            version: version,
            build: build.rawValue
        )
    }
}

extension APIClientInfo {
    public func encodeAsHTTPHeaders() -> [String: String] {[
        Self.HTTPHeaderName.id: id,
        Self.HTTPHeaderName.version: String(version),
        Self.HTTPHeaderName.build: String(build),
    ]}
}
