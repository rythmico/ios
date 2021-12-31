import FoundationEncore

extension LessonPlan.Options {
    static let pendingStub = Self(
        pause: nil,
        resume: nil,
        cancel: .stub
    )

    static let reviewingStub = Self(
        pause: nil,
        resume: nil,
        cancel: .stub
    )

    static let activeStub = Self(
        pause: .stub,
        resume: nil,
        cancel: .stub
    )

    static let pausedStub = Self(
        pause: nil,
        resume: .stub,
        cancel: .stub
    )

    static let cancelledStub = Self(
        pause: nil,
        resume: nil,
        cancel: nil
    )
}

// MARK: - Pause -

extension LessonPlan.Options.Pause {
    static let stub = Self(policy: .stub)
}

extension LessonPlan.Options.Pause.Policy {
    static let stub = Self(
        freeBeforeDate: try! .stub - (24, .hour, .neutral),
        freeBeforePeriod: .init(hours: 24)
    )
}

// MARK: - Resume -

extension LessonPlan.Options.Resume {
    static let stub = Self(policy: .stub)
}

extension LessonPlan.Options.Resume.Policy {
    static let stub = Self(
        allAfterPeriod: .init(hours: 24)
    )
}

// MARK: - Cancel -

extension LessonPlan.Options.Cancel {
    static let stub = Self(policy: .stub)
}

extension LessonPlan.Options.Cancel.Policy {
    static let stub = Self(
        freeBeforeDate: try! .stub - (24, .hour, .neutral),
        freeBeforePeriod: .init(hours: 24)
    )
}
