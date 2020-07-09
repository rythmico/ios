import Foundation

enum Gender: String, Equatable, Codable, CaseIterable, Hashable {
    case male = "MALE"
    case female = "FEMALE"

    var name: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
