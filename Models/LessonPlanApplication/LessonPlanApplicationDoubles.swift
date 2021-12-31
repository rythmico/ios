import TutorDTO

extension LessonPlanApplication {
    static func stub(_ status: Status) -> Self {
        Self(
            id: .init(rawValue: UUID().uuidString),
            createdAt: try! .stub - (32, .second, .neutral),
            request: LessonPlanRequest(
                id: .init(rawValue: UUID().uuidString),
                submitterName: "David",
                instrument: .stub(.piano),
                student: .jackStub,
                address: .stub,
                schedule: .startingTomorrowStub,
                privateNote: ""
            ),
            privateNote: "I'll help!",
            status: status
        )
    }

    static let stub = stub(.pending)

    static let stubWithAbout = stub(.pending) => {
        $0.request.privateNote = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        $0.privateNote = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    }

    static let longStub = stub(.pending) => {
        $0.createdAt = try! .stub - (1, .weekOfYear, .neutral)
        $0.request.privateNote = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        $0.request.student = .davidStubNoAbout
        $0.privateNote = ""
    }
}

extension Array where Element == LessonPlanApplication {
    static let stub: Self = [
        .pending
    ]
    .map(Element.stub)
}
