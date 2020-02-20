import Foundation
import Sugar

protocol RequestLessonPlanContextProtocol: AnyObject {
    var instrument: Instrument? { get set }
    var updateHandler: Handler<RequestLessonPlanContextProtocol>? { get set }
}

final class RequestLessonPlanContext: RequestLessonPlanContextProtocol {
    var instrument: Instrument? { didSet { updateHandler?(self) } }
    var updateHandler: Handler<RequestLessonPlanContextProtocol>?
}
