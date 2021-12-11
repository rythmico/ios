import FoundationEncore
import TutorDO

extension LessonPlanRequest.ID {
    static func random() -> Self {
        .init(rawValue: UUID().uuidString)
    }
}

extension LessonPlanRequest {
    static let stub = Self.init(
        id: .random(),
        submitterName: "David R",
        instrument: .stub(.piano),
        student: .jackStub,
        address: .stub,
        schedule: .startingTomorrowStub,
        privateNote: ""
    )

    static let stubWithAbout = Self(
        id: .random(),
        submitterName: "David R",
        instrument: .stub(.guitar),
        student: .janeStub,
        address: .stub => (\.districtCode, "N8"),
        schedule: .startingTomorrowStub,
        privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )

    static let longStub = Self(
        id: .random(),
        submitterName: "David R",
        instrument: .stub(.piano),
        student: .davidStubNoAbout,
        address: .stub => (\.districtCode, "NW5"),
        schedule: .startingIn1WeekStub,
        privateNote: ""
    )
}
