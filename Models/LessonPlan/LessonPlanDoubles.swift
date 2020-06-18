import Foundation
import Then

extension LessonPlan: Then {}

extension LessonPlan {
    static var jackGuitarPlanStub: LessonPlan {
        LessonPlan(
            id: "jack_guitar",
            status: .pending,
            instrument: .guitar,
            student: .jackStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var jesseDrumsPlanStub: LessonPlan {
        LessonPlan(
            id: "jesse_drums",
            status: .pending,
            instrument: .drums,
            student: .jesseStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var charlottePianoPlanStub: LessonPlan {
        LessonPlan(
            id: "charlotte_piano",
            status: .pending,
            instrument: .piano,
            student: .charlotteStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var janeSingingPlanStub: LessonPlan {
        LessonPlan(
            id: "jane_singing",
            status: .pending,
            instrument: .singing,
            student: .janeStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var davidGuitarPlanStub: LessonPlan {
        LessonPlan(
            id: "david_guitar",
            status: .pending,
            instrument: .guitar,
            student: .davidStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }
}

extension LessonPlan {
    static var cancelledJackGuitarPlanStub: LessonPlan {
        jackGuitarPlanStub.with {
            $0.status = .cancelled(nil, .stub)
        }
    }
}

extension LessonPlan.CancellationInfo {
    static var stub: LessonPlan.CancellationInfo {
        LessonPlan.CancellationInfo(
            date: Date(),
            reason: .rearrangementNeeded
        )
    }
}

extension Array where Element == LessonPlan {
    static var stub: Self {
        [
            .jackGuitarPlanStub,
            .jesseDrumsPlanStub,
            .charlottePianoPlanStub,
            .janeSingingPlanStub
        ]
    }
}
