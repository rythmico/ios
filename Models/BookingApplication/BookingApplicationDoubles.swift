import FoundationEncore

extension BookingApplication {
    static func stub(_ statusInfo: StatusInfo) -> Self {
        .init(
            id: UUID().uuidString,
            lessonPlanRequestId: UUID().uuidString,
            createdAt: try! .stub - (32, .second, .neutral),
            statusInfo: statusInfo,
            instrument: .stub(.piano),
            submitterName: "David R",
            submitterPrivateNote: "",
            phoneNumber: statusInfo.status == .selected ? .stub : nil,
            student: .jackStub,
            addressInfo: statusInfo.status == .selected ? .address(.stub) : .postcode("N8"),
            schedule: .startingTomorrowStub,
            privateNote: "I'll help!"
        )
    }

    static let stub = Self(
        id: UUID().uuidString,
        lessonPlanRequestId: UUID().uuidString,
        createdAt: try! .stub - (32, .second, .neutral),
        statusInfo: .stub(.pending),
        instrument: .stub(.piano),
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
        lessonPlanRequestId: UUID().uuidString,
        createdAt: try! .stub - (32, .second, .neutral),
        statusInfo: .stub(.pending),
        instrument: .stub(.guitar),
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
        lessonPlanRequestId: UUID().uuidString,
        createdAt: try! .stub - (1, .weekOfYear, .neutral),
        statusInfo: .stub(.pending),
        instrument: .stub(.piano),
        submitterName: "David R",
        submitterPrivateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        phoneNumber: nil,
        student: .davidStubNoAbout,
        addressInfo: .postcode("NW5"),
        schedule: .startingIn1WeekStub,
        privateNote: ""
    )
}

extension Array where Element == BookingApplication {
    static let stub: Self = BookingApplication.Status.allCases.map { .stub(.stub($0)) }
}

extension BookingApplication.StatusInfo {
    static func stub(_ status: BookingApplication.Status) -> Self {
        .init(
            status: status,
            date: try! .stub - (58, .second, .neutral)
        )
    }
}
