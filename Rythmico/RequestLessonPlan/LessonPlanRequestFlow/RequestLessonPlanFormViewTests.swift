import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanFormViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func formView() throws -> (RequestLessonPlanContext, RequestLessonPlanFormView) {
        let context = RequestLessonPlanContext()
        let view = try XCTUnwrap(
            RequestLessonPlanFormView(
                context: context,
                coordinator: XCTUnwrap(Current.lessonPlanRequestCoordinator())
            )
        )
        return (context, view)
    }

    func testInitialValues() throws {
        let (_, view) = try formView()

        XCTAssertView(view) { view in
            XCTAssertFalse(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 1)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.instrumentSelectionView)
        }
    }

    func testStudentDetailsPresentation() throws {
        let (context, view) = try formView()

        XCTAssertView(view) { view in
            context.instrument = .guitar

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 2)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.studentDetailsView)
        }
    }

    func testAddressDetailsPresentation() throws {
        let (context, view) = try formView()

        XCTAssertView(view) { view in
            context.instrument = .guitar
            context.student = .davidStub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 3)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.addressDetailsView)
        }
    }

    func testSchedulingViewPresentation() throws {
        let (context, view) = try formView()

        XCTAssertView(view) { view in
            context.instrument = .guitar
            context.student = .davidStub
            context.address = .stub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 4)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.schedulingView)
        }
    }

    func testPrivateNoteViewPresentation() throws {
        let (context, view) = try formView()

        XCTAssertView(view) { view in
            context.instrument = .guitar
            context.student = .davidStub
            context.address = .stub
            context.schedule = .stub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 5)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.privateNoteView)
        }
    }

    func testReviewRequestViewPresentation() throws {
        let (context, view) = try formView()

        XCTAssertView(view) { view in
            context.instrument = .guitar
            context.student = .davidStub
            context.address = .stub
            context.schedule = .stub
            context.privateNote = "Note"

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 6)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.reviewRequestView)
        }
    }
}
