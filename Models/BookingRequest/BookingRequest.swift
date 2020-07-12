import Foundation

struct BookingRequest: Equatable, Decodable, Identifiable, Hashable {
    struct Student: Equatable, Decodable, Hashable {
        var name: String
        var age: Int
        var gender: Gender
        var about: String
    }

    var id: String
    var createdAt: Date
    var instrument: Instrument
    var submitterName: String
    var student: Student
    var postcode: String
    var schedule: Schedule
    var privateNote: String
}
