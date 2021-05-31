import Foundation
import ISO8601PeriodDuration
import Tagged

struct LessonPlan: Identifiable, Hashable {
    enum Status: Decodable, Hashable {
        case pending
        case reviewing([Application])
        case active([Lesson], Tutor) // TODO: swap `Tutor` with `BookingInfo`
        case paused([Lesson], Tutor, PauseInfo) // TODO: swap `Tutor` with `BookingInfo`
        case cancelled([Lesson]?, Tutor?, CancellationInfo) // TODO: swap `Tutor` with `BookingInfo`

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let applications = try container.decodeIfPresent([Application].self, forKey: .applications)
            let lessons = try container.decodeIfPresent([Lesson].self, forKey: .lessons)
            let bookingInfo = try container.decodeIfPresent(BookingInfo.self, forKey: .bookingInfo)
            let pauseInfo = try container.decodeIfPresent(PauseInfo.self, forKey: .pauseInfo)
            let cancellationInfo = try container.decodeIfPresent(CancellationInfo.self, forKey: .cancellationInfo)

            switch (applications, lessons, bookingInfo, pauseInfo, cancellationInfo) {
            case (_, let lessons, let bookingInfo, _, let cancellationInfo?):
                self = .cancelled(lessons, bookingInfo?.tutor, cancellationInfo)
            case (_, let lessons?, let bookingInfo?, let pauseInfo?, _):
                self = .paused(lessons, bookingInfo.tutor, pauseInfo)
            case (_, let lessons?, let bookingInfo?, _, _):
                self = .active(lessons, bookingInfo.tutor)
            case (let applications?, _, _, _, _) where !applications.isEmpty:
                self = .reviewing(applications)
            default:
                self = .pending
            }
        }
    }

    struct Application: Decodable, Hashable {
        var tutor: Tutor
        var privateNote: String
    }

    struct BookingInfo: Decodable, Hashable {
        var date: Date
        var tutor: Tutor
    }

    struct PauseInfo: Decodable, Hashable {
        var date: Date
    }

    struct CancellationInfo: Decodable, Hashable {
        enum Reason: String, Codable, Hashable, CaseIterable {
            case tooExpensive = "TOO_EXPENSIVE"
            case badTutor = "BAD_TUTOR"
            case rearrangementNeeded = "NEED_REARRANGEMENT"
            case other = "OTHER"
        }

        var date: Date
        var reason: Reason
    }

    struct Options: Decodable, Hashable {
        struct Pause: Decodable, Hashable {
            var freeBefore: Date
            @ISO8601PeriodDuration
            var freeWithin: DateComponents
        }
        struct Resume: Decodable, Hashable {
            @ISO8601PeriodDuration
            var allOutside: DateComponents
        }
        struct Cancel: Decodable, Hashable {
            var freeBefore: Date?
            @OptionalISO8601PeriodDuration
            var freeWithin: DateComponents?
        }

        var pause: Pause?
        var resume: Resume?
        var cancel: Cancel?
    }

    typealias ID = Tagged<Self, String>

    var id: ID
    var status: Status
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String
    var options: Options
}

extension LessonPlan: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            id: container.decode(ID.self, forKey: .id),
            status: Status(from: decoder),
            instrument: container.decode(Instrument.self, forKey: .instrument),
            student: container.decode(Student.self, forKey: .student),
            address: container.decode(Address.self, forKey: .address),
            schedule: container.decode(Schedule.self, forKey: .schedule),
            privateNote: container.decode(String.self, forKey: .privateNote),
            options: container.decode(Options.self, forKey: .options)
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case applications // Status
        case bookingInfo // Status
        case pauseInfo // Status
        case cancellationInfo // Status
        case lessons // Status
        case instrument
        case student
        case address
        case schedule
        case privateNote
        case options
    }
}

extension LessonPlan {
    var lessons: [Lesson]? {
        switch status {
        case .active(let lessons, _), .paused(let lessons, _, _):
            return lessons
        case .cancelled(let lessons, _, _):
            return lessons
        case .pending, .reviewing:
            return nil
        }
    }
}

extension LessonPlan.Status {
    var isPending: Bool {
        guard case .pending = self else { return false }
        return true
    }

    var isReviewing: Bool {
        guard case .reviewing = self else { return false }
        return true
    }

    var isPaused: Bool {
        guard case .paused = self else { return false }
        return true
    }

    var isCancelled: Bool {
        guard case .cancelled = self else { return false }
        return true
    }

    var reviewingValue: [LessonPlan.Application]? {
        guard case .reviewing(let applications) = self else { return nil }
        return applications
    }
}
