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
    var student: Student
    var instrument: Instrument
    var number: Int
    var tutor: Tutor
    var status: Status
    var address: Address
    var schedule: Schedule
}

extension Lesson.Status {
    var isCancelled: Bool {
        guard case .cancelled = self else { return false }
        return true
    }
}
