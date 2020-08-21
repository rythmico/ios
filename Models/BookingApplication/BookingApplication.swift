import Foundation

struct BookingApplication: Equatable, Decodable, Identifiable, Hashable {
    enum Status: String, Decodable, Hashable {
        case pending = "PENDING"
    }

    struct StatusInfo: Equatable, Decodable, Hashable {
        var status: Status
        var date: Date
    }

    struct Student: Equatable, Decodable, Hashable {
        var name: String
        var age: Int
        var gender: Gender
        var about: String
    }

    var id: String
    var bookingRequestId: String
    var createdAt: Date
    var statusInfo: StatusInfo
    var instrument: Instrument
    var submitterName: String
    var submitterPrivateNote: String
    var student: Student
    var postcode: String
    var schedule: Schedule
    var privateNote: String
}
