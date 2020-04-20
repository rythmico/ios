import Foundation

struct Student: Equatable {
    var name: String
    var dateOfBirth: Date
    var gender: Gender
    var about: String
}

enum Gender: Equatable, CaseIterable {
    case male
    case female

    var name: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
