import Foundation
import Sugar

extension BookingApplication {
    static var stub: Self {
        .init(
            id: "ID1",
            bookingRequestId: "ID1",
            createdAt: AppEnvironment.dummy.date() - (32, .second),
            statusInfo: .stub,
            instrument: .piano,
            submitterName: "David R",
            submitterPrivateNote: "I'll help!",
            student: .jackStub,
            postcode: "N8",
            schedule: .startingTomorrowStub,
            privateNote: ""
        )
    }

    static var stubWithAbout: Self {
        .init(
            id: "ID3",
            bookingRequestId: "ID3",
            createdAt: AppEnvironment.dummy.date() - (32, .second),
            statusInfo: .stub,
            instrument: .guitar,
            submitterName: "David R",
            submitterPrivateNote: "I'll help!",
            student: .janeStub,
            postcode: "N8",
            schedule: .startingTomorrowStub,
            privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        )
    }

    static var longStub: Self {
        .init(
            id: "ID2",
            bookingRequestId: "ID2",
            createdAt: AppEnvironment.dummy.date() - (1, .weekOfMonth),
            statusInfo: .stub,
            instrument: .piano,
            submitterName: "David R",
            submitterPrivateNote: "I'll help!",
            student: .longNameStub,
            postcode: "NW5",
            schedule: .startingIn1WeekStub,
            privateNote: ""
        )
    }
}

extension BookingApplication.Student {
    static var jackStub: Self {
        .init(
            name: "Jack",
            age: 10,
            gender: .male,
            about: ""
        )
    }

    static var janeStub: Self {
        .init(
            name: "Jane",
            age: 9,
            gender: .female,
            about: "Jane is in Year 5. She has had a few guitar lessons at school and seems to really enjoy learning."
        )
    }

    static var longNameStub: Self {
        .init(
            name: "Ana De la Rosa San Cristo del Poder González Martínez Jiménez",
            age: 30,
            gender: .female,
            about: ""
        )
    }
}

extension BookingApplication.StatusInfo {
    static var stub: Self {
        .init(
            status: .pending,
            date: AppEnvironment.dummy.date() - (58, .second)
        )
    }
}
