import Foundation
import Then

extension Lesson: Then {}

extension Lesson.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }
}

extension Array where Element == Lesson {
    static let stub: Self =
        [.stub(status: .scheduled, startDate: .stub)]
        +
        (1..<5).map {
            .stub(
                status: .random() ? .cancelled : .completed,
                startDate: .stub - ($0, .weekOfMonth)
            )
        }
}

extension Lesson {
    static let scheduledStub = stub(status: .scheduled, startDate: .stub)
    static let cancelledStub = stub(status: .cancelled, startDate: .stub)
    static let completedStub = stub(status: .completed, startDate: .stub)
}

private extension Lesson {
    static func stub(status: Status, startDate: Date) -> Self {
        Self(
            id: .random(),
            status: status,
            instrument: .guitar,
            student: .jackStub,
            tutor: .jesseStub,
            address: .stub,
            schedule: Schedule.stub.with(\.startDate, startDate)
        )
    }
}
