import Foundation

struct Student: Equatable, Codable, Hashable {
    var name: String
    var dateOfBirth: Date
    var gender: Gender
    var about: String
}

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
