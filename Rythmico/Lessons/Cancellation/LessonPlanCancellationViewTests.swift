import XCTest
@testable import Rythmico
import ViewInspector

extension LessonPlanCancellationView: Inspectable {}

final class LessonPlanCancellationViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testCancellationSubmission() throws {
        let spy = APIServiceSpy<CancelLessonPlanRequest>()
        Current.stubAPIEndpoint(for: \.lessonPlanCancellationCoordinator, service: spy)

        let view = try XCTUnwrap(LessonPlanCancellationView(lessonPlan: .pendingDavidGuitarPlanStub, option: .stub))
        XCTAssertView(view) { view in
            XCTAssertNil(spy.latestRequest?.lessonPlanId)
            XCTAssertNil(spy.latestRequest?.body.reason)
            view.submit(.badTutor)
            XCTAssertEqual(spy.latestRequest?.lessonPlanId, LessonPlan.pendingDavidGuitarPlanStub.id)
            XCTAssertEqual(spy.latestRequest?.body.reason, .badTutor)
        }
    }
}
