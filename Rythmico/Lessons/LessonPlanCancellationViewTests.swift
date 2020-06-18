import XCTest
@testable import Rythmico

final class LessonPlanCancellationViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testCancellationSubmission() throws {
        let spy = LessonPlanCancellationServiceSpy()
        Current.lessonPlanCancellationService = spy

        let view = try XCTUnwrap(
            LessonPlanCancellationView(lessonPlan: .davidGuitarPlanStub, onSuccessfulCancellation: {})
        )

        XCTAssertView(view) { view in
            XCTAssertNil(spy.latestRequestLessonPlanId)
            XCTAssertNil(spy.latestRequestReason)
            view.submit(.badTutor)
            XCTAssertEqual(spy.latestRequestLessonPlanId, LessonPlan.davidGuitarPlanStub.id)
            XCTAssertEqual(spy.latestRequestReason, .badTutor)
        }
    }
}
