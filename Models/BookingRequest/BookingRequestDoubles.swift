import Foundation
import Sugar

extension BookingRequest {
    static var stub: BookingRequest {
        BookingRequest(
            id: "ID1",
            createdAt: AppEnvironment.dummy.date() - (32, .second),
            instrument: .piano,
            submitterName: "David R",
            student: .jackStub,
            postcode: "N8",
            schedule: .startingTomorrowStub,
            privateNote: ""
        )
    }

    static var longStub: BookingRequest {
        BookingRequest(
            id: "ID2",
            createdAt: AppEnvironment.dummy.date() - (1, .weekOfMonth),
            instrument: .piano,
            submitterName: "David R",
            student: .longNameStub,
            postcode: "NW5",
            schedule: .startingIn1WeekStub,
            privateNote: ""
        )
    }
}

extension BookingRequest.Student {
    static var jackStub: Self {
        .init(
            name: "Jack",
            age: 10,
            gender: .male,
            about: ""
        )
    }

    static var longNameStub: Self {
        .init(
            name: "Ana De la Rosa San Cristo del Poder",
            age: 30,
            gender: .female,
            about: ""
        )
    }
}
