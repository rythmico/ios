import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanFormViewTests: XCTestCase {
    var formView: (RequestLessonPlanContext, RequestLessonPlanFormView) {
        let context = RequestLessonPlanContext()
        let instrumentProvider = InstrumentSelectionListProviderStub(instruments: [.guitar, .piano])
        let view = RequestLessonPlanFormView(
            context: context,
            coordinator: RequestLessonPlanCoordinatorDummy(),
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            instrumentProvider: instrumentProvider,
            keyboardDismisser: KeyboardDismisserSpy()
        )
        return (context, view)
    }

    func testInitialValues() {
        let (_, view) = formView

        XCTAssertView(view) { view in
            XCTAssertFalse(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 1)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.instrumentSelectionView)
        }
    }

    func testStudentDetailsPresentation() {
        let (context, view) = formView

        XCTAssertView(view) { view in
            context.instrument = .guitar

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 2)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.studentDetailsView)
        }
    }

    func testAddressDetailsPresentation() {
        let (context, view) = formView

        XCTAssertView(view) { view in
            context.instrument = .guitar
            context.student = .davidStub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 3)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.addressDetailsView)
        }
    }

    func testSchedulingViewPresentation() {
        let (context, view) = formView

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

    func testPrivateNoteViewPresentation() {
        let (context, view) = formView

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

    func testReviewRequestViewPresentation() {
        let (context, view) = formView

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
