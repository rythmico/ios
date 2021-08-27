public let kCFBundleShortVersionKey = "CFBundleShortVersionString" as CFString

public protocol BundleProtocol {
    var infoDictionary: [String: Any]? { get }
}

extension BundleProtocol {
    public typealias ID = Tagged<Bundle, String>
    public typealias Build = Tagged<Bundle, UInt>

    public var id: ID? { infoValue(ID.self, for: kCFBundleIdentifierKey) }
    public var version: Version? { infoValue(Version.self, for: kCFBundleShortVersionKey) }
    public var build: Build? { infoValue(Build.self, for: kCFBundleVersionKey) }

    private func infoValue<Value: LosslessStringConvertible>(_ type: Value.Type, for key: CFString) -> Value? {
        infoDictionary?[key as String]
            .flatMap { $0 as? String }
            .flatMap { $0.nilIfBlank }
            .flatMap(Value.init)
    }
}

extension Bundle: BundleProtocol {}
