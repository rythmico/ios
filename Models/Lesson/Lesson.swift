import Foundation
import Tagged

struct Lesson: Equatable, Decodable, Identifiable, Hashable {
    typealias ID = Tagged<Self, String>

    enum Status: String, Equatable, Decodable, Hashable {
        case scheduled = "SCHEDULED"
        case cancelled = "CANCELLED"
        case completed = "COMPLETED"
    }

    var id: ID
    var status: Status
    var instrument: Instrument
    var student: Student
    var tutor: Tutor
    var address: Address
    var schedule: Schedule
}
