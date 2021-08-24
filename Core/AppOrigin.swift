import FoundationEncore

extension App {
    enum Origin: Equatable, Hashable {
        case testFlight
        case appStore

        func url(forAppId appId: ID) -> URL {
            switch self {
            case .testFlight:
                return URL(string: "itms-beta://beta.itunes.apple.com/v1/app/\(appId)")!
            case .appStore:
                return URL(string: "https://apps.apple.com/app/id\(appId)")!
            }
        }
    }
}
