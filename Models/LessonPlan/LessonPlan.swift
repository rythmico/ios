import Foundation

struct LessonPlan: Equatable, Decodable, Identifiable, Hashable {
    enum Status: Equatable, Decodable, Hashable {
        case pending
        case reviewing([Tutor])
        case scheduled(Tutor)
        case cancelled(Tutor?, CancellationInfo)

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let applicants = try container.decodeIfPresent([Tutor].self, forKey: .applicants)
            let tutor = try container.decodeIfPresent(Tutor.self, forKey: .tutor)
            let cancellationInfo = try container.decodeIfPresent(CancellationInfo.self, forKey: .cancellationInfo)
            switch (applicants, tutor, cancellationInfo) {
            case (_, let tutor, let cancellationInfo?):
                self = .cancelled(tutor, cancellationInfo)
            case (_, let tutor?, _):
                self = .scheduled(tutor)
            case (let applicants?, _, _) where !applicants.isEmpty:
                self = .reviewing(applicants)
            default:
                self = .pending
            }
        }
    }

    struct Tutor: Equatable, Decodable, Hashable {
        var id: String
        var name: String
        var imageURL: URL
    }

    struct CancellationInfo: Equatable, Decodable, Hashable {
        enum Reason: String, Decodable, Hashable {
            case tooExpensive = "TOO_EXPENSIVE"
            case badTutor = "BAD_TUTOR"
            case rearrangementWanted = "REARRANGEMENT_WANTED"
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
        self.id = try container.decode(String.self, forKey: .id)
        self.status = try Status(from: decoder)
        self.instrument = try container.decode(Instrument.self, forKey: .instrument)
        self.student = try container.decode(Student.self, forKey: .student)
        self.address = try container.decode(Address.self, forKey: .address)
        self.schedule = try container.decode(Schedule.self, forKey: .schedule)
        self.privateNote = try container.decode(String.self, forKey: .privateNote)
    }

    private enum CodingKeys: String, CodingKey {
        case id

        // Status
        case applicants
        case tutor
        case cancellationInfo

        case instrument
        case student
        case address
        case schedule
        case privateNote
    }
}
