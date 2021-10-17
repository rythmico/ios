import FoundationEncore

extension BookingRequest {
    static let stub = Self(
        id: UUID().uuidString,
        createdAt: .stub - (32, .second, .neutral),
        instrument: .piano,
        submitterName: "David R",
        student: .jackStub,
        postcode: "N8",
        schedule: .startingTomorrowStub,
        privateNote: ""
    )

    static let stubWithAbout = Self(
        id: UUID().uuidString,
        createdAt: .stub - (32, .second, .neutral),
        instrument: .guitar,
        submitterName: "David R",
        student: .janeStub,
        postcode: "N8",
        schedule: .startingTomorrowStub,
        privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )

    static let longStub = Self(
        id: UUID().uuidString,
        createdAt: .stub - (1, .weekOfYear, .neutral),
        instrument: .piano,
        submitterName: "David R",
        student: .davidStubNoAbout,
        postcode: "NW5",
        schedule: .startingIn1WeekStub,
        privateNote: ""
    )
}
