import Foundation
import Then

extension Booking: Then {}

extension Booking.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }
}

extension Booking {
    static let jackGuitarBookingStub = Self(
        id: .random(),
        instrument: .guitar,
        student: .jackStub,
        address: .stub,
        schedule: .stub,
        phoneNumber: .stub,
        privateNote: "",
        lessons: .stub
    )
}

extension Array where Element == Booking {
    static let stub: Self = [
        .jackGuitarBookingStub,
    ]
}
