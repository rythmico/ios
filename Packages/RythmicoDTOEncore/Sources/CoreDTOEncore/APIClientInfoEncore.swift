extension BundleProtocol {
    public var clientInfo: APIClientInfo? {
        guard
            let id = (id?.rawValue).flatMap(APIClientInfo.ID.init),
            let version = version,
            let build = build
        else {
            return nil
        }
        return APIClientInfo(
            id: id,
            version: version,
            build: build.rawValue
        )
    }
}
