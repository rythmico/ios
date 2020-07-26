import XCTest
@testable import Rythmico
import struct SwiftUI.Image
import ViewInspector

extension RequestLessonPlanView: Inspectable {}

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
            view.coordinator.run(with: .stub)

            XCTAssertNil(view.formView)
            XCTAssertNotNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
        }
    }

    func testFailureState() throws {
        Current.lessonPlanRequestService = APIServiceStub(result: .failure("Something 2"))

        let view = try XCTUnwrap(RequestLessonPlanView(context: RequestLessonPlanContext()))

        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNotNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
            XCTAssertEqual(view.errorMessage, "Something 2")

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }

    func testConfirmationState() throws {
        Current.lessonPlanRequestService = APIServiceStub(result: .success(.jackGuitarPlanStub))

        let view = try XCTUnwrap(RequestLessonPlanView(context: RequestLessonPlanContext()))

        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNotNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
            XCTAssertNil(view.errorMessage)
        }
    }
}

private extension CreateLessonPlanRequest.Body {
    static let stub = CreateLessonPlanRequest.Body(
        instrument: .guitar,
        student: .davidStub,
        address: .stub,
        schedule: .stub,
        privateNote: "Note"
    )
}
