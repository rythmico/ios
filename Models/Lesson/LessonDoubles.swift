import Foundation
import FoundationSugar
import Then

extension Lesson: Then {}

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
                startDate: .stub - ($0, .weekOfMonth, .current)
            )
        }
    }
}

extension Lesson {
    static let scheduledStub = stub(week: 0, status: .scheduled, startDate: .stub)
    static let skippedStub = stub(week: 1, status: .skipped, startDate: .stub)
    static let completedStub = stub(week: 2, status: .completed, startDate: .stub)
}

private extension Lesson {
    #if RYTHMICO
    static func stub(week: Int?, status: Status, startDate: Date) -> Self {
        Self(
            id: .random(),
            lessonPlanId: .stub,
            student: .jackStub,
            instrument: .guitar,
            week: week,
            tutor: .jesseStub,
            status: status,
            address: .stub,
            schedule: Schedule.stub.with(\.startDate, startDate),
            freeSkipUntil: status == .scheduled ? startDate - (3, .hour, .current) : nil
        )
    }
    #elseif TUTOR
    static func stub(week: Int?, status: Status, startDate: Date) -> Self {
        Self(
            id: .random(),
            student: .jackStub,
            instrument: .guitar,
            week: week,
            status: status,
            address: .stub,
            schedule: Schedule.stub.with(\.startDate, startDate),
            phoneNumber: .stub,
            privateNote: ""
        )
    }
    #endif
}

