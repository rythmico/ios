import Foundation

enum Gender: String, Equatable, Codable, CaseIterable, Hashable {
    case male = "MALE"
    case female = "FEMALE"
    case other = "OTHER"

    var name: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        }
    }
}
