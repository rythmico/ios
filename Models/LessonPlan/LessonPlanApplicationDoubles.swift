import FoundationSugar

extension LessonPlan.Application {
    static let jesseStub = Self(tutor: .jesseStub, privateNote: "I'll help!")
    static let davidStub = Self(tutor: .davidStub, privateNote: "Lorem ipsum!")
    static let charlotteStub = Self(tutor: .charlotteStub, privateNote: "")
}

extension LessonPlan.Applications {
    static let stub = Self(
        .jesseStub,
        .davidStub,
        .charlotteStub
    )
}
