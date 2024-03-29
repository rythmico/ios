import CoreDTO
import FoundationEncore

extension Lesson.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }
}

extension Array where Element == Lesson {
    static let lessonCount = 6
    static var stub: Self {
        [.stub(week: lessonCount-1, status: .scheduled, startDate: .stub)]
        +
        (1..<lessonCount).map {
            .stub(
                week: lessonCount-$0-1,
                status: .random() ? .skipped : .completed,
                startDate: try! .stub - ($0, .weekOfYear, .neutral)
            )
        }
    }
}

extension Lesson {
    static let scheduledStub = stub(week: 0, status: .scheduled, startDate: .stub)
    static let completedStub = stub(week: 1, status: .completed, startDate: .stub)
    static let skippedStub = stub(week: 2, status: .skipped, startDate: .stub)
    static let pausedStub = stub(week: 3, status: .paused, startDate: .stub)
    static let cancelledStub = stub(week: 4, status: .cancelled, startDate: .stub)
}

private extension Lesson {
    #if RYTHMICO
    static func stub(week: Int?, status: Status, startDate: Date) -> Self {
        Self(
            id: .random(),
            lessonPlanId: .stub,
            student: .jackStub,
            instrument: .stub(.guitar),
            week: week,
            tutor: .jesseStub,
            status: status,
            address: .stub,
            schedule: Schedule.stub => (\.startDate, startDate),
            options: status == .scheduled ? .scheduledStub : .skippedStub
        )
    }
    #elseif TUTOR
    static func stub(week: Int?, status: Status, startDate: Date) -> Self {
        Self(
            id: .random(),
            student: .jackStub,
            instrument: .stub(.guitar),
            week: week,
            status: status,
            address: .stub,
            schedule: Schedule.stub => (\.startDate, startDate),
            phoneNumber: .stub,
            privateNote: ""
        )
    }
    #endif
}

#if RYTHMICO
extension Lesson.Options {
    static let scheduledStub = Self(
        skip: .stub
    )

    static let skippedStub = Self(
        skip: nil
    )
}

extension Lesson.Options.Skip {
    static let stub = Self(policy: .stub)
}

extension Lesson.Options.Skip.Policy {
    static let stub = Self(
        freeBeforeDate: try! .stub - (24, .hour, .neutral),
        freeBeforePeriod: .init(hours: 24)
    )
}
#endif
