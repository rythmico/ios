import Foundation

enum TutorStatus: Decodable {
    case notRegistered(formURL: URL)
    case notCurated
    case notDBSChecked
    case verified

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(Status.self, forKey: .status)
        switch status {
        case .statusNotRegistered:
            let formURL = try container.decode(URL.self, forKey: .formURL)
            self = .notRegistered(formURL: formURL)
        case .statusNotCurated:
            self = .notCurated
        case .statusNotDBSChecked:
            self = .notDBSChecked
        case .statusVerified:
            self = .verified
        }
    }

    private enum CodingKeys: String, CodingKey {
        case status
        case formURL
    }

    private enum Status: String, Decodable {
        case statusNotRegistered = "NOT_REGISTERED"
        case statusNotCurated = "NOT_CURATED"
        case statusNotDBSChecked = "NOT_DBS_CHECKED"
        case statusVerified = "VERIFIED"
    }
}
