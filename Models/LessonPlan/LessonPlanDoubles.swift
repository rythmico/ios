import Foundation
import Then

extension LessonPlan: Then {}

extension LessonPlan.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }
}

extension LessonPlan {
    static let pendingJackGuitarPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .guitar,
        student: .jackStub,
        address: .stub,
        schedule: .stub,
        privateNote: ""
    )

    static let jesseDrumsPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .drums,
        student: .jesseStub,
        address: .stub,
        schedule: .stub,
        privateNote: ""
    )

    static let charlottePianoPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .piano,
        student: .charlotteStub,
        address: .stub,
        schedule: .stub,
        privateNote: ""
    )

    static let janeSingingPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .singing,
        student: .janeStub,
        address: .stub,
        schedule: .stub,
        privateNote: ""
    )

    static let davidGuitarPlanStub = Self(
        id: .random(),
        status: .pending,
        instrument: .guitar,
        student: .davidStub,
        address: .stub,
        schedule: .stub,
        privateNote: ""
    )
}

extension LessonPlan {
    static let reviewingJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .reviewing(.stub)
    }
}

extension LessonPlan {
    static let scheduledJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .scheduled(.stub, .jesseStub)
    }
}

extension LessonPlan {
    static let cancelledJackGuitarPlanStub = pendingJackGuitarPlanStub.with {
        $0.status = .cancelled(nil, nil, .stub)
    }

    static let cancelledCharlottePianoPlanStub = charlottePianoPlanStub.with {
        $0.status = .cancelled(.stub, .jesseStub, .stub)
    }
}

extension LessonPlan.Application {
    static let jesseStub = Self(tutor: .jesseStub, privateNote: "I'll help!")
    static let davidStub = Self(tutor: .davidStub, privateNote: "Lorem ipsum!")
    static let charlotteStub =  Self(tutor: .charlotteStub, privateNote: "")
}

extension LessonPlan.CancellationInfo {
    static let stub = Self(
        date: .stub,
        reason: .rearrangementNeeded
    )
}

extension Array where Element == LessonPlan {
    static let stub: Self = [
        .jesseDrumsPlanStub,
//        .reviewingJackGuitarPlanStub,
        .scheduledJackGuitarPlanStub,
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
