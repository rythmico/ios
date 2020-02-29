import Foundation
import Sugar

protocol RequestLessonPlanContextProtocol: AnyObject {
    var instrument: Instrument? { get set }
    var student: Student? { get set }
    var updateHandler: Handler<RequestLessonPlanContextProtocol>? { get set }
}

final class RequestLessonPlanContext: RequestLessonPlanContextProtocol {
    var instrument: Instrument? { didSet { updateHandler?(self) } }
    var student: Student? { didSet { updateHandler?(self) } }
    var updateHandler: Handler<RequestLessonPlanContextProtocol>?

    init(
        instrument: Instrument? = nil,
        student: Student? = nil
    ) {
        self.instrument = instrument
        self.student = student
    }
}
