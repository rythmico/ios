import Foundation
import PhoneNumberKit
import Tagged

struct Lesson: Equatable, Decodable, Identifiable, Hashable {
    typealias ID = Tagged<Self, String>

    enum Status: String, Equatable, Decodable, Hashable {
        case skipped = "SKIPPED"
        case completed = "COMPLETED"
        case scheduled = "SCHEDULED"
    }

    var id: ID
    #if RYTHMICO
    var lessonPlanId: LessonPlan.ID
    #elseif TUTOR
    // TODO
    // var bookingId: Booking.ID
    #endif
    var student: Student
    var instrument: Instrument
    var week: Int?
    #if RYTHMICO
    var tutor: Tutor
    #elseif TUTOR
    #endif
    var status: Status
    var address: Address
    var schedule: Schedule
    #if RYTHMICO
    var freeSkipUntil: Date?
    #elseif TUTOR
    @E164PhoneNumber
    var phoneNumber: PhoneNumber
    var privateNote: String
    #endif
}

extension Lesson.Status {
    var isScheduled: Bool { self == .scheduled }
    var isSkipped: Bool { self == .skipped }
    var isCompleted: Bool { self == .completed }
}

extension Lesson {
    var title: String {
        [
            student.name.firstWord,
            [instrument.assimilatedName, "Lesson", orderDescriptor].spaced()
        ]
        .compact()
        .spacedAndDashed()
    }

    private var orderDescriptor: String {
        week.map { String($0 + 1) } ?? "(Extra)"
    }
}
