import XCTest
@testable import Rythmico
import struct SwiftUI.Image
import ViewInspector

extension RequestLessonPlanFlowView: Inspectable {}

final class RequestLessonPlanFlowViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func flowView() -> (RequestLessonPlanFlow, RequestLessonPlanFlowView) {
        let flow = RequestLessonPlanFlow()
        let view = RequestLessonPlanFlowView(
            flow: flow,
            requestCoordinator: Current.lessonPlanRequestCreationCoordinator()
        )
        return (flow, view)
    }

    func testInitialValues() {
        let (flow, view) = flowView()

        XCTAssertView(view) { view in
            XCTAssertFalse(view.shouldShowBackButton)
            XCTAssertEqual(view.stepNumber, 1)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertEqual(flow.step, .instrumentSelection)
        }
    }

    func testStudentDetailsPresentation() {
        let (flow, view) = flowView()

        XCTAssertView(view) { view in
            flow.instrument = .stub(.guitar)

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.stepNumber, 2)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertEqual(flow.step, .studentDetails(.stub(.guitar)))
        }
    }

    func testAddressDetailsPresentation() {
        let (flow, view) = flowView()

        XCTAssertView(view) { view in
            flow.instrument = .stub(.guitar)
            flow.student = .davidStub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.stepNumber, 3)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertEqual(flow.step, .addressDetails(.stub(.guitar), .davidStub))
        }
    }

    func testSchedulingViewPresentation() {
        let (flow, view) = flowView()

        XCTAssertView(view) { view in
            flow.instrument = .stub(.guitar)
            flow.student = .davidStub
            flow.address = .stub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.stepNumber, 4)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertEqual(flow.step, .scheduling(.stub(.guitar), .davidStub, .stub))
        }
    }

    func testPrivateNoteViewPresentation() {
        let (flow, view) = flowView()

        XCTAssertView(view) { view in
            flow.instrument = .stub(.guitar)
            flow.student = .davidStub
            flow.address = .stub
            flow.schedule = .stub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.stepNumber, 5)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertEqual(flow.step, .privateNote(.stub(.guitar), .davidStub, .stub, .stub))
        }
    }

    func testReviewRequestViewPresentation() {
        let (flow, view) = flowView()

        XCTAssertView(view) { view in
            flow.instrument = .stub(.guitar)
            flow.student = .davidStub
            flow.address = .stub
            flow.schedule = .stub
            flow.privateNote = "Note"

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.stepNumber, 6)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertEqual(flow.step, .reviewRequest(.stub(.guitar), .davidStub, .stub, .stub, "Note"))
        }
    }
}
