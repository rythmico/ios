import FoundationEncore

extension LessonPlan {
    static var stub: Self { pendingJackGuitarPlanStub }

    static let pendingJackGuitarPlanStub = Self(
        id: .stub,
        status: .pending,
        instrument: .stub(.guitar),
        student: .jackStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingJesseDrumsPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .stub(.drums),
        student: .jesseStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingCharlottePianoPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .stub(.piano),
        student: .charlotteStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingJaneSingingPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .stub(.singing),
        student: .janeStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )

    static let pendingDavidGuitarPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .stub(.guitar),
        student: .davidStub,
        address: .stub,
        schedule: .stub,
        privateNote: "",
        options: .pendingStub
    )
}

extension LessonPlan {
    static let reviewingJackGuitarPlanStub = pendingJackGuitarPlanStub => {
        $0.status = .reviewing(.stub)
        $0.options = .reviewingStub
    }
}

extension LessonPlan {
    static let activeJackGuitarPlanStub = pendingJackGuitarPlanStub => {
        $0.status = .active(.stub)
        $0.options = .activeStub
    }

    static let activeSkippedJackGuitarPlanStub = pendingJackGuitarPlanStub => {
        $0.status = .active(.stub)
        $0.options = .activeStub
    }
}

extension LessonPlan {
    static let pausedJackGuitarPlanStub = pendingJackGuitarPlanStub => {
        $0.status = .paused(.stub)
        $0.options = .pausedStub
    }
}

extension LessonPlan {
    static let cancelledJackGuitarPlanStub = pendingJackGuitarPlanStub => {
        $0.status = .cancelled(.stub)
        $0.options = .cancelledStub
    }

    static let cancelledCharlottePianoPlanStub = pendingCharlottePianoPlanStub => {
        $0.status = .cancelled(.stub)
        $0.options = .cancelledStub
    }
}

extension Array where Element == LessonPlan {
    static let stub: Self = [
        .pendingJesseDrumsPlanStub,
//        .reviewingJackGuitarPlanStub,
        .activeJackGuitarPlanStub,
        .cancelledCharlottePianoPlanStub,
    ]
}
