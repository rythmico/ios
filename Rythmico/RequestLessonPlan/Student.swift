import Foundation

struct Student {
    var name: String
    var dateOfBirth: Date
    var gender: Gender
    var about: String?
}

enum Gender: Equatable, CaseIterable {
    case male
    case female
}
