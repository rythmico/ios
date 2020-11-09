import Foundation
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
        [.stub(number: lessonCount, status: .scheduled, startDate: .stub)]
        +
        (1..<lessonCount).map {
            .stub(
                number: lessonCount-$0,
                status: .random() ? .cancelled : .completed,
                startDate: .stub - ($0, .weekOfMonth)
            )
        }
    }
}

extension Lesson {
    static let scheduledStub = stub(number: 1, status: .scheduled, startDate: .stub)
    static let cancelledStub = stub(number: 2, status: .cancelled, startDate: .stub)
    static let completedStub = stub(number: 3, status: .completed, startDate: .stub)
}

private extension Lesson {
    static func stub(number: Int, status: Status, startDate: Date) -> Self {
        Self(
            id: .random(),
            student: .jackStub,
            instrument: .guitar,
            number: number,
            tutor: .jesseStub,
            status: status,
            address: .stub,
            schedule: Schedule.stub.with(\.startDate, startDate)
        )
    }
}