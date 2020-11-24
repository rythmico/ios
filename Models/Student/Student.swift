import Foundation

struct Student: Equatable, Codable, Hashable {
    var name: String
    #if RYTHMICO
    var dateOfBirth: Date
    #elseif TUTOR
    var age: Int
    #endif
    var gender: Gender
    var about: String
}
