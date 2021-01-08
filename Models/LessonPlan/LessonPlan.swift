import Foundation
import Tagged

struct LessonPlan: Equatable, Identifiable, Hashable {
    enum Status: Equatable, Decodable, Hashable {
        case pending
        case reviewing([Application])
        case scheduled([Lesson], Tutor)
        case cancelled([Lesson]?, Tutor?, CancellationInfo)

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let applications = try container.decodeIfPresent([Application].self, forKey: .applications)
            let lessons = try container.decodeIfPresent([Lesson].self, forKey: .lessons)
            let bookingInfo = try container.decodeIfPresent(BookingInfo.self, forKey: .bookingInfo)
            let cancellationInfo = try container.decodeIfPresent(CancellationInfo.self, forKey: .cancellationInfo)
            switch (applications, lessons, bookingInfo, cancellationInfo) {
            case (_, let lessons, let bookingInfo, let cancellationInfo?):
                self = .cancelled(lessons, bookingInfo?.tutor, cancellationInfo)
            case (_, let lessons?, let bookingInfo?, _) where !lessons.isEmpty:
                self = .scheduled(lessons, bookingInfo.tutor)
            case (let applications?, _, _, _) where !applications.isEmpty:
                self = .reviewing(applications)
            default:
                self = .pending
            }
        }
    }

    struct Application: Equatable, Decodable, Hashable {
        var tutor: Tutor
        var privateNote: String
    }

    struct BookingInfo: Equatable, Decodable, Hashable {
        var date: Date
        var tutor: Tutor
    }

    struct CancellationInfo: Equatable, Decodable, Hashable {
        enum Reason: String, Codable, Hashable, CaseIterable {
            case tooExpensive = "TOO_EXPENSIVE"
            case badTutor = "BAD_TUTOR"
            case rearrangementNeeded = "NEED_REARRANGEMENT"
            case other = "OTHER"
        }

        var date: Date
        var reason: Reason
    }

    typealias ID = Tagged<Self, String>

    var id: ID
    var status: Status
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String
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
            privateNote: container.decode(String.self, forKey: .privateNote)
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case applications // Status
        case bookingInfo // Status
        case cancellationInfo // Status
        case lessons // Status
        case instrument
        case student
        case address
        case schedule
        case privateNote
    }
}

extension LessonPlan {
    var lessons: [Lesson]? {
        switch status {
        case .scheduled(let lessons, _):
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

    var isCancelled: Bool {
        guard case .cancelled = self else { return false }
        return true
    }

    var reviewingValue: [LessonPlan.Application]? {
        guard case .reviewing(let applications) = self else { return nil }
        return applications
    }
}
