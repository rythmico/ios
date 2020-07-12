import Foundation

extension BookingRequest {
    static var stub: BookingRequest {
        BookingRequest(
            id: "ID1",
            createdAt: Date() - 32,
            instrument: .piano,
            submitterName: "David R",
            student: .jackStub,
            postcode: "N8",
            schedule: .stub,
            privateNote: ""
        )
    }

    static var longStub: BookingRequest {
        BookingRequest(
            id: "ID2",
            createdAt: Date(timeIntervalSince1970: 0),
            instrument: .piano,
            submitterName: "David R",
            student: .longNameStub,
            postcode: "NW5",
            schedule: .stub,
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
