import FoundationEncore

enum APIClientInfo {
    static let current = [
        "Client-Id": Bundle.main.id?.rawValue,
        "Client-Version": Bundle.main.version.map(String.init),
        "Client-Build": Bundle.main.build.map(\.rawValue).map(String.init),
    ]
    .compacted()
}
