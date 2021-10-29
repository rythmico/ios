import FoundationEncore
import PhoneNumberKit
#if RYTHMICO
import StudentDTO
#elseif TUTOR
import TutorDTO
#endif

struct Lesson: Decodable, Identifiable, Hashable {
    typealias ID = Tagged<Self, String>

    enum Status: String, Decodable, Hashable {
        case scheduled = "SCHEDULED"
        case completed = "COMPLETED"
        case skipped = "SKIPPED"
        case paused = "PAUSED"
        case cancelled = "CANCELLED"
    }

    #if RYTHMICO
    struct Options: Decodable, Hashable {
        struct Skip: Decodable, Hashable {
            struct Policy: Decodable, Hashable {
                var freeBeforeDate: Date
                var freeBeforePeriod: PeriodDuration
            }
            var policy: Policy
        }
        var skip: Skip?
    }
    #endif

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
    var options: Options
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
        .compacted()
        .spacedAndDashed()
    }

    private var orderDescriptor: String {
        week.map { String($0 + 1) } ?? "(Extra)"
    }
}

extension RangeReplaceableCollection where Element == Lesson {
    func nextLesson() -> Lesson? {
        self.lazy
            .filter { Current.date() < $0.schedule.endDate }
            .min(by: \.schedule.startDate)
    }

    func filterUpcoming() -> [Lesson] {
        self.lazy
            .filter { Current.date() < $0.schedule.endDate }
            .sorted(by: \.schedule.startDate, <)
    }

    func filterPast() -> [Lesson] {
        self.lazy
            .filter { Current.date() > $0.schedule.endDate }
            .sorted(by: \.schedule.startDate, >)
    }
}
