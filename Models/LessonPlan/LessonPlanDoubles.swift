#if DEBUG
import Foundation
import Then

extension LessonPlan: Then {}

extension LessonPlan {
    static var pendingJackGuitarPlanStub: Self {
        .init(
            id: "jack_guitar",
            status: .pending,
            instrument: .guitar,
            student: .jackStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var jesseDrumsPlanStub: Self {
        .init(
            id: "jesse_drums",
            status: .pending,
            instrument: .drums,
            student: .jesseStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var charlottePianoPlanStub: Self {
        .init(
            id: "charlotte_piano",
            status: .pending,
            instrument: .piano,
            student: .charlotteStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var janeSingingPlanStub: Self {
        .init(
            id: "jane_singing",
            status: .pending,
            instrument: .singing,
            student: .janeStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }

    static var davidGuitarPlanStub: Self {
        .init(
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
    static var reviewingJackGuitarPlanStub: Self {
        pendingJackGuitarPlanStub.with {
            $0.status = .reviewing([.stub, .stub])
        }
    }
}

extension LessonPlan {
    static var cancelledJackGuitarPlanStub: Self {
        pendingJackGuitarPlanStub.with {
            $0.status = .cancelled(nil, .stub)
        }
    }

    static var cancelledCharlottePianoPlanStub: Self {
        charlottePianoPlanStub.with {
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
    static var stub: Self {
        .init(
            date: .stub,
            reason: .rearrangementNeeded
        )
    }
}

extension Array where Element == LessonPlan {
    static var stub: Self {
        [
            .jesseDrumsPlanStub,
            .reviewingJackGuitarPlanStub,
            .cancelledCharlottePianoPlanStub,
        ]
    }
}
#endif
