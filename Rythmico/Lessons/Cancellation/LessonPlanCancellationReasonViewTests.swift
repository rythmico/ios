import XCTest
@testable import Rythmico
import ViewInspector

extension LessonPlanCancellationView.ReasonView: Inspectable {}

final class LessonPlanCancellationReasonViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testSubmitVisibilityAndHandling() throws {
        let expectation = self.expectation(description: "Handler")

        let expectedReason = LessonPlan.CancellationInfo.Reason.tooExpensive
        let view = LessonPlanCancellationView.ReasonView(lessonPlan: .pendingJackGuitarPlanStub) { reason in
            XCTAssertEqual(reason, expectedReason)
            expectation.fulfill()
        }

        XCTAssertView(view) { view in
            XCTAssertNil(view.selectedReason)
            XCTAssertNil(view.submitButtonAction)
            view.selectedReason = expectedReason
            view.submitButtonAction?()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testRearrangementNeededDisablesSubmitButton() throws {
        let view = LessonPlanCancellationView.ReasonView(lessonPlan: .pendingJackGuitarPlanStub) { _ in}

        XCTAssertView(view) { view in
            XCTAssertNil(view.selectedReason)
            XCTAssertNil(view.submitButtonAction)
            XCTAssertFalse(view.submitButtonDisabled)
            view.selectedReason = .rearrangementNeeded
            XCTAssertNotNil(view.submitButtonAction)
            XCTAssertTrue(view.submitButtonDisabled)
        }
    }
}
