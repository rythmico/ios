import Foundation

struct LessonPlan: Equatable, Decodable {
    enum Status: String, Equatable, Decodable {
        case pending = "PENDING"
    }

    var status: Status
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String
}
