import Foundation

extension LessonPlan {
    static var stub: LessonPlan {
        LessonPlan(
            id: "ID123",
            status: .pending,
            instrument: .guitar,
            student: .davidStub,
            address: .stub,
            schedule: .stub,
            privateNote: ""
        )
    }
}
