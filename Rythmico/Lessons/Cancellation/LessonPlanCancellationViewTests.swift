import XCTest
@testable import Rythmico
import ViewInspector

extension LessonPlanCancellationView: Inspectable {}

final class LessonPlanCancellationViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testCancellationSubmission() {
        let spy = APIServiceSpy<CancelLessonPlanRequest>()
        Current.stubAPIEndpoint(for: \.lessonPlanCancellationCoordinator, service: spy)

        let view = LessonPlanCancellationView(lessonPlan: .davidGuitarPlanStub)
        XCTAssertView(view) { view in
            XCTAssertNil(spy.latestRequest?.lessonPlanId)
            XCTAssertNil(spy.latestRequest?.body.reason)
            view.submit(.badTutor)
            XCTAssertEqual(spy.latestRequest?.lessonPlanId, LessonPlan.davidGuitarPlanStub.id)
            XCTAssertEqual(spy.latestRequest?.body.reason, .badTutor)
        }
    }
}
