import Foundation
import Tagged

struct LessonPlan: Equatable, Identifiable, Hashable {
    enum Status: Equatable, Decodable, Hashable {
        case pending
        case reviewing([Application])
        case scheduled(Tutor)
        case cancelled(Tutor?, CancellationInfo)

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let applications = try container.decodeIfPresent([Application].self, forKey: .applications)
            let bookingInfo = try container.decodeIfPresent(BookingInfo.self, forKey: .bookingInfo)
            let cancellationInfo = try container.decodeIfPresent(CancellationInfo.self, forKey: .cancellationInfo)
            switch (applications, bookingInfo, cancellationInfo) {
            case (_, let bookingInfo, let cancellationInfo?):
                self = .cancelled(bookingInfo?.tutor, cancellationInfo)
            case (_, let bookingInfo?, _):
                self = .scheduled(bookingInfo.tutor)
            case (let applications?, _, _) where !applications.isEmpty:
                self = .reviewing(applications)
            default:
                self = .pending
            }
        }
    }

    struct Tutor: Identifiable, Equatable, Decodable, Hashable {
        typealias ID = Tagged<Self, String>

        var id: ID
        var name: String
        var photoThumbnailURL: ImageReference?
        var photoURL: ImageReference?
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
        case instrument
        case student
        case address
        case schedule
        case privateNote
    }
}

extension LessonPlan.Status {
    var isCancelled: Bool {
        guard case .cancelled = self else { return false }
        return true
    }

    var reviewingValue: [LessonPlan.Application]? {
        guard case .reviewing(let applications) = self else { return nil }
        return applications
    }
}
