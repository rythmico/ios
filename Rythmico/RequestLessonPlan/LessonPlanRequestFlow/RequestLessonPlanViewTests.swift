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
        let view = RequestLessonPlanView(flow: RequestLessonPlanFlow())
        XCTAssertView(view) { view in
            XCTAssertNotNil(view.flowView)
            XCTAssertFalse(view.interactiveDismissDisabled)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLoadingState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCreationCoordinator, service: APIServiceDummy())

        let view = RequestLessonPlanView(flow: RequestLessonPlanFlow())
        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNil(view.flowView)
            XCTAssertTrue(view.interactiveDismissDisabled)
        }
    }

    func testFailureState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCreationCoordinator, result: .failure("Something 2"))

        let view = RequestLessonPlanView(flow: RequestLessonPlanFlow())
        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNotNil(view.flowView)
            XCTAssertTrue(view.interactiveDismissDisabled)
            XCTAssertEqual(view.errorMessage, "Something 2")

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }

    func testConfirmationState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestCreationCoordinator, result: .success(.stub))

        let view = RequestLessonPlanView(flow: RequestLessonPlanFlow())
        XCTAssertView(view) { view in
            view.coordinator.run(with: .stub)

            XCTAssertNil(view.flowView)
            XCTAssertTrue(view.interactiveDismissDisabled)
            XCTAssertNil(view.errorMessage)
        }
    }
}

private extension CreateLessonPlanRequestRequest {
    static let stub = CreateLessonPlanRequestRequest(
        body: .init(
            instrument: .known(.guitar),
            student: .davidStub,
            address: .stub,
            schedule: .stub,
            privateNote: "Note"
        )
    )
}
