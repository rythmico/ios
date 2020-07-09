import Foundation

extension BookingRequest {
    static var stub: BookingRequest {
        BookingRequest(
            id: "ID123",
            instrument: .piano,
            submitterName: "David R",
            student: .jackStub,
            postcode: "N8",
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
}
