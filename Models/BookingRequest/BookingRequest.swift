import Foundation

struct BookingRequest: Equatable, Decodable, Identifiable, Hashable {
    var id: String
    var createdAt: Date
    var instrument: Instrument
    var submitterName: String
    var student: Student
    var postcode: String
    var schedule: Schedule
    var privateNote: String
}
