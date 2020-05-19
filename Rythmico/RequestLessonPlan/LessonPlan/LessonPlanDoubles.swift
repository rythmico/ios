import Foundation

extension LessonPlan {
    static var stub: LessonPlan {
        LessonPlan(
            status: .pending,
            instrument: .guitar,
            student: .davidStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }
}
