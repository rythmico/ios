import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testIdleState() throws {
        let view = try XCTUnwrap(RequestLessonPlanView(context: RequestLessonPlanContext()))

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertTrue(view.swipeDownToDismissEnabled)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLoadingState() throws {
        let view = try XCTUnwrap(RequestLessonPlanView(context: RequestLessonPlanContext()))

        XCTAssertView(view) { view in
            view.coordinator.requestLessonPlan(.stub)

            XCTAssertNil(view.formView)
            XCTAssertNotNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
        }
    }

    func testFailureState() throws {
        Current.lessonPlanRequestService = LessonPlanRequestServiceStub(result: .failure("Something"))

        let view = try XCTUnwrap(RequestLessonPlanView(context: RequestLessonPlanContext()))

        XCTAssertView(view) { view in
            view.coordinator.requestLessonPlan(.stub)

            XCTAssertNotNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
            XCTAssertEqual(view.errorMessage, "Something")
        }
    }

    func testConfirmationState() throws {
        Current.lessonPlanRequestService = LessonPlanRequestServiceStub(result: .success(.stub))

        let view = try XCTUnwrap(RequestLessonPlanView(context: RequestLessonPlanContext()))

        XCTAssertView(view) { view in
            view.coordinator.requestLessonPlan(.stub)

            XCTAssertNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNotNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
            XCTAssertNil(view.errorMessage)
        }
    }
}

private extension LessonPlanRequestBody {
    static let stub = LessonPlanRequestBody(
        instrument: .guitar,
        student: .davidStub,
        address: .stub,
        schedule: .stub,
        privateNote: "Note"
    )
}
