import Foundation

struct Student: Equatable, Codable, Hashable {
    var name: String
    var dateOfBirth: Date
    var gender: Gender
    var about: String
}
