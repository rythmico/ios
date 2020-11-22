import Foundation
import Tagged

struct Lesson: Equatable, Decodable, Identifiable, Hashable {
    typealias ID = Tagged<Self, String>

    enum Status: String, Equatable, Decodable, Hashable {
        case scheduled = "SCHEDULED"
        case skipped = "SKIPPED"
        case completed = "COMPLETED"
    }

    var id: ID
    #if RYTHMICO
    var planId: LessonPlan.ID
    #elseif TUTOR
    // TODO
    // var bookingId: Booking.ID
    #endif
    var student: Student
    var instrument: Instrument
    var number: Int
    #if RYTHMICO
    var tutor: Tutor
    #elseif TUTOR
    #endif
    var status: Status
    var address: Address
    var schedule: Schedule
}

extension Lesson.Status {
    var isSkipped: Bool {
        guard case .skipped = self else { return false }
        return true
    }
}
