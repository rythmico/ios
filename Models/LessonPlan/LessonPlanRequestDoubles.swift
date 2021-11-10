import StudentDTO

extension LessonPlanRequest {
    static let stub = Self(
        id: .stub,
        status: .pending,
        instrument: .stub(.guitar),
        student: .jackStub,
        address: .stub,
        schedule: .stub,
        privateNote: ""
    )
}
