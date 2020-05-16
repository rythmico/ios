import Foundation

struct LessonPlan: Equatable, Decodable {
    enum Status: String, Equatable, Decodable {
        case pending = "PENDING"
    }

    enum ParsingError: Swift.Error {
        case instrumentNotFound
    }

    var status: Status
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let instrumentId = try container.decode(String.self, forKey: .instrument)
        guard let instrument = [Instrument].allInstrumentsStub.first(where: { $0.id == instrumentId }) else {
            throw ParsingError.instrumentNotFound
        }
        try self.init(
            status: container.decode(Status.self, forKey: .status),
            instrument: instrument,
            student: container.decode(Student.self, forKey: .student),
            address: container.decode(Address.self, forKey: .address),
            schedule: container.decode(Schedule.self, forKey: .schedule),
            privateNote: container.decode(String.self, forKey: .privateNote)
        )
    }

    init(
        status: Status,
        instrument: Instrument,
        student: Student,
        address: Address,
        schedule: Schedule,
        privateNote: String
    ) {
        self.status = status
        self.instrument = instrument
        self.student = student
        self.address = address
        self.schedule = schedule
        self.privateNote = privateNote
    }

    private enum CodingKeys: String, CodingKey {
        case status
        case instrument
        case student
        case address
        case schedule
        case privateNote
    }
}
