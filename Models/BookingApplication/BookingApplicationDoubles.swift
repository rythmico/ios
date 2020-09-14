#if DEBUG
import Foundation
import Sugar

extension BookingApplication {
    static func stub(_ statusInfo: StatusInfo) -> Self {
        .init(
            id: UUID().uuidString,
            bookingRequestId: UUID().uuidString,
            createdAt: .stub - (32, .second),
            statusInfo: statusInfo,
            instrument: .piano,
            submitterName: "David R",
            submitterPrivateNote: "",
            phoneNumber: statusInfo.status == .selected ? "+44 5555 666666" : nil,
            student: .jackStub,
            addressInfo: statusInfo.status == .selected ? .address(.stub) : .postcode("N8"),
            schedule: .startingTomorrowStub,
            privateNote: "I'll help!"
        )
    }

    static let stub = Self(
        id: UUID().uuidString,
        bookingRequestId: UUID().uuidString,
        createdAt: .stub - (32, .second),
        statusInfo: .stub(.pending),
        instrument: .piano,
        submitterName: "David R",
        submitterPrivateNote: "",
        phoneNumber: nil,
        student: .jackStub,
        addressInfo: .postcode("N8"),
        schedule: .startingTomorrowStub,
        privateNote: "I'll help!"
    )

    static let stubWithAbout = Self(
        id: UUID().uuidString,
        bookingRequestId: UUID().uuidString,
        createdAt: .stub - (32, .second),
        statusInfo: .stub(.pending),
        instrument: .guitar,
        submitterName: "David R",
        submitterPrivateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        phoneNumber: nil,
        student: .janeStub,
        addressInfo: .postcode("N8"),
        schedule: .startingTomorrowStub,
        privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )

    static let longStub = Self(
        id: UUID().uuidString,
        bookingRequestId: UUID().uuidString,
        createdAt: .stub - (1, .weekOfMonth),
        statusInfo: .stub(.pending),
        instrument: .piano,
        submitterName: "David R",
        submitterPrivateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        phoneNumber: nil,
        student: .longNameStub,
        addressInfo: .postcode("NW5"),
        schedule: .startingIn1WeekStub,
        privateNote: ""
    )
}

extension Array where Element == BookingApplication {
    static let stub: Self = BookingApplication.Status.allCases.map { .stub(.stub($0)) }
}

extension BookingApplication.Student {
    static let jackStub = Self(
        name: "Jack",
        age: 10,
        gender: .male,
        about: ""
    )

    static let janeStub = Self(
        name: "Jane",
        age: 9,
        gender: .female,
        about: "Jane is in Year 5. She has had a few guitar lessons at school and seems to really enjoy learning."
    )

    static let longNameStub = Self(
        name: "Ana De la Rosa San Cristo del Poder González Martínez Jiménez",
        age: 30,
        gender: .female,
        about: ""
    )
}

extension BookingApplication.StatusInfo {
    static func stub(_ status: BookingApplication.Status) -> Self {
        .init(
            status: status,
            date: .stub - (58, .second)
        )
    }
}
#endif
