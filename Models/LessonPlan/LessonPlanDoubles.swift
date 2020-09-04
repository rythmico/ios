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
    static var reviewingJackGuitarPlanStub: LessonPlan {
        jackGuitarPlanStub.with {
            $0.status = .reviewing([.stub, .stub])
        }
    }
}

extension LessonPlan {
    static var cancelledJackGuitarPlanStub: LessonPlan {
        jackGuitarPlanStub.with {
            $0.status = .cancelled(nil, .stub)
        }
    }
}

extension LessonPlan.Application {
    static var stub: Self {
        .init(tutor: .jesseStub, privateNote: "I'll help!")
    }
}

extension LessonPlan.Tutor {
    static var jesseStub: Self {
        .init(
            id: "ID1",
            name: "Jesse Bildner",
            photoThumbnailURL: nil,
            photoURL: nil
        )
    }
}

extension LessonPlan.CancellationInfo {
    static var stub: LessonPlan.CancellationInfo {
        LessonPlan.CancellationInfo(
            date: .stub,
            reason: .rearrangementNeeded
        )
    }
}

extension Array where Element == LessonPlan {
    static var stub: Self {
        [
            .reviewingJackGuitarPlanStub,
            .jesseDrumsPlanStub,
            .charlottePianoPlanStub,
            .janeSingingPlanStub
        ]
    }
}
