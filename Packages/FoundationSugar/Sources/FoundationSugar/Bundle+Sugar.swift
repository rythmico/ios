extension Bundle {
    public typealias ID = Tagged<Bundle, String>
    public typealias Build = Tagged<Bundle, Int>

    public var id: ID? { infoStringValue(for: kCFBundleIdentifierKey).flatMap(ID.init) }
    public var version: Version? { infoStringValue(for: "CFBundleShortVersionString" as CFString).flatMap(Version.init) }
    public var build: Build? { infoStringValue(for: kCFBundleVersionKey).flatMap(Int.init).flatMap(Build.init) }

    private func infoStringValue(for key: CFString) -> String? {
        object(forInfoDictionaryKey: key as String) as? String
    }
}
