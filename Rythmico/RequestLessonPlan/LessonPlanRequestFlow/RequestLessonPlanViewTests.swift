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

    func testReadyState() throws {
        let view = RequestLessonPlanView(context: RequestLessonPlanContext())
        XCTAssertView(view) { view in
            XCTAssertNotNil(view.formView)
            XCTAssertTrue(view.swipeDownToDismissEnabled)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLoadingState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCoordinator, service: APIServiceDummy())

        let view = RequestLessonPlanView(context: RequestLessonPlanContext())
        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNil(view.formView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
        }
    }

    func testFailureState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCoordinator, result: .failure("Something 2"))

        let view = RequestLessonPlanView(context: RequestLessonPlanContext())
        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNotNil(view.formView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
            XCTAssertEqual(view.errorMessage, "Something 2")

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }

    func testConfirmationState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCoordinator, result: .success(.pendingJackGuitarPlanStub))

        let view = RequestLessonPlanView(context: RequestLessonPlanContext())
        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNil(view.formView)
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
