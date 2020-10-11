import Foundation
import Sugar

extension BookingRequest {
    static let stub = Self(
        id: UUID().uuidString,
        createdAt: .stub - (32, .second),
        instrument: .piano,
        submitterName: "David R",
        student: .jackStub,
        postcode: "N8",
        schedule: .startingTomorrowStub,
        privateNote: ""
    )

    static let stubWithAbout = Self(
        id: UUID().uuidString,
        createdAt: .stub - (32, .second),
        instrument: .guitar,
        submitterName: "David R",
        student: .janeStub,
        postcode: "N8",
        schedule: .startingTomorrowStub,
        privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )

    static let longStub = Self(
        id: UUID().uuidString,
        createdAt: .stub - (1, .weekOfMonth),
        instrument: .piano,
        submitterName: "David R",
        student: .longNameStub,
        postcode: "NW5",
        schedule: .startingIn1WeekStub,
        privateNote: ""
    )
}

extension BookingRequest.Student {
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
