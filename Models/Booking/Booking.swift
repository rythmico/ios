import FoundationEncore
import TutorDTO

struct Booking: Equatable, Identifiable, Hashable {
    typealias ID = Tagged<Self, String>

    var id: ID
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var phoneNumber: PhoneNumber
    var privateNote: String
    var lessons: [Lesson]
}

extension Booking: Decodable {}
