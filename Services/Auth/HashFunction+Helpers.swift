import FoundationSugar
import CryptoKit

extension HashFunction {
    static func hash(utf8String: String) -> Self.Digest {
        hash(data: Data(utf8String.utf8))
    }

    static func hashString(utf8String: String) -> String {
        hashString(data: Data(utf8String.utf8))
    }

    static func hashString<D: DataProtocol>(data: D) -> String {
        hash(data: data)
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
}
