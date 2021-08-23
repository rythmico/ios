public let kCFBundleShortVersionKey = "CFBundleShortVersionString" as CFString

extension Bundle {
    public typealias ID = Tagged<Bundle, String>
    public typealias Build = Tagged<Bundle, Int>

    public var id: ID? { infoValue(ID.self, for: kCFBundleIdentifierKey) }
    public var version: Version? { infoValue(Version.self, for: kCFBundleShortVersionKey) }
    public var build: Build? { infoValue(Build.self, for: kCFBundleVersionKey) }

    private func infoValue<Value: LosslessStringConvertible>(_ type: Value.Type, for key: CFString) -> Value? {
        object(forInfoDictionaryKey: key as String).flatMap { $0 as? String }.flatMap(Value.init)
    }
}
