import Foundation

struct LessonPlan: Equatable, Decodable, Identifiable, Hashable {
    enum Status: Equatable, Decodable, Hashable {
        case pending
        case reviewing([Application])
        case scheduled(Tutor)
        case cancelled(Tutor?, CancellationInfo)

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let applications = try container.decodeIfPresent([Application].self, forKey: .applications)
            let tutor = try container.decodeIfPresent(Tutor.self, forKey: .tutor)
            let cancellationInfo = try container.decodeIfPresent(CancellationInfo.self, forKey: .cancellationInfo)
            switch (applications, tutor, cancellationInfo) {
            case (_, let tutor, let cancellationInfo?):
                self = .cancelled(tutor, cancellationInfo)
            case (_, let tutor?, _):
                self = .scheduled(tutor)
            case (let applications?, _, _) where !applications.isEmpty:
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

    struct Tutor: Equatable, Decodable, Hashable {
        var id: String
        var name: String
        var photoURL: URL?
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

    var id: String
    var status: Status
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String

    init(
        id: String,
        status: Status,
        instrument: Instrument,
        student: Student,
        address: Address,
        schedule: Schedule,
        privateNote: String
    ) {
        self.id = id
        self.status = status
        self.instrument = instrument
        self.student = student
        self.address = address
        self.schedule = schedule
        self.privateNote = privateNote
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            id: container.decode(String.self, forKey: .id),
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
        case tutor // Status
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
        guard case .cancelled = self else {
            return false
        }
        return true
    }
}
