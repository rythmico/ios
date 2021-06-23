import FoundationSugar

extension LessonPlan: Then {}

extension LessonPlan.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }

    static let stub = random()
}

extension LessonPlan {
    static let pendingJackGuitarPlanStub = Self(
        id: .stub,
        status: .pending,
        instrument: .guitar,
        student: .jackStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingJesseDrumsPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .drums,
        student: .jesseStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingCharlottePianoPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .piano,
        student: .charlotteStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingJaneSingingPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .singing,
        student: .janeStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingDavidGuitarPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .guitar,
        student: .davidStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )
}

extension LessonPlan {
    static let reviewingJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .reviewing(.stub)
        $0.options = .reviewingStub
    }
}

extension LessonPlan {
    static let activeJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .active(.stub, .jesseStub)
        $0.options = .activeStub
    }

    static let activeSkippedJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .active(.stub, .jesseStub)
        $0.options = .activeStub
    }
}

extension LessonPlan {
    static let pausedJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .paused(.stub, .jesseStub, .stub)
        $0.options = .pausedStub
    }
}

extension LessonPlan {
    static let cancelledJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .cancelled(nil, nil, .stub)
        $0.options = .cancelledStub
    }

    static let cancelledCharlottePianoPlanStub = pendingCharlottePianoPlanStub.with {
        $0.status = .cancelled(.stub, .jesseStub, .stub)
        $0.options = .cancelledStub
    }
}

extension LessonPlan.Application {
    static let jesseStub = Self(tutor: .jesseStub, privateNote: "I'll help!")
    static let davidStub = Self(tutor: .davidStub, privateNote: "Lorem ipsum!")
    static let charlotteStub = Self(tutor: .charlotteStub, privateNote: "")
}

extension LessonPlan.PauseInfo {
    static let stub = Self(date: .stub)
}

extension LessonPlan.CancellationInfo {
    static let stub = Self(
        date: .stub,
        reason: .rearrangementNeeded
    )
}

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

extension LessonPlan.Options.Pause {
    static let stub = Self(policy: .stub)
}

extension LessonPlan.Options.Pause.Policy {
    static let stub = Self(
        freeBeforeDate: .stub - (24, .hour, .current),
        freeBeforePeriod: .init(.init(hour: 24))
    )
}

extension LessonPlan.Options.Resume {
    static let stub = Self(policy: .stub)
}

extension LessonPlan.Options.Resume.Policy {
    static let stub = Self(
        allAfterPeriod: .init(.init(hour: 24))
    )
}

extension LessonPlan.Options.Cancel {
    static let stub = Self(policy: .stub)
}

extension LessonPlan.Options.Cancel.Policy {
    static let stub = Self(
        freeBeforeDate: .stub - (24, .hour, .current),
        freeBeforePeriod: .init(.init(hour: 24))
    )
}

extension Array where Element == LessonPlan {
    static let stub: Self = [
        .pendingJesseDrumsPlanStub,
//        .reviewingJackGuitarPlanStub,
        .activeJackGuitarPlanStub,
        .cancelledCharlottePianoPlanStub,
    ]
}

extension Array where Element == LessonPlan.Application {
    static let stub: Self = [
        .jesseStub,
        .davidStub,
        .charlotteStub
    ]
}
