import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanViewTests: XCTestCase {
    var requestLessonPlanView: (RequestLessonPlanContext, RequestLessonPlanView) {
        let context = RequestLessonPlanContext()
        let instrumentProvider = InstrumentSelectionListProviderStub(instruments: [.guitarStub, .pianoStub])
        let view = RequestLessonPlanView(
            context: context,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            instrumentProvider: instrumentProvider
        )
        return (context, view)
    }

    func testInitialValues() {
        let (_, view) = requestLessonPlanView

        XCTAssertView(view) { view in
            XCTAssertFalse(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 1)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.instrumentSelectionView)
        }
    }

    func testStudentDetailsPresentation() {
        let (context, view) = requestLessonPlanView

        XCTAssertView(view) { view in
            context.instrument = .guitarStub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 2)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.studentDetailsView)
        }
    }

    func testAddressDetailsPresentation() {
        let (context, view) = requestLessonPlanView

        XCTAssertView(view) { view in
            context.instrument = .guitarStub
            context.student = .davidStub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 3)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.addressDetailsView)
        }
    }

    func testSchedulingViewPresentation() {
        let (context, view) = requestLessonPlanView

        XCTAssertView(view) { view in
            context.instrument = .guitarStub
            context.student = .davidStub
            context.address = .stub

            XCTAssertTrue(view.shouldShowBackButton)
            XCTAssertEqual(view.currentStepNumber, 4)
            XCTAssertEqual(view.stepCount, 6)
            XCTAssertNotNil(view.schedulingView)
        }
    }

    // TODO: testPrivateNoteViewPresentation
    // TODO: testReviewProposalViewPresentation
    // TODO: testRequestConfirmationViewPresentation
}
