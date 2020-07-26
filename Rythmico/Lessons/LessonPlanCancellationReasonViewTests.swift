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

        let expectedReason = LessonPlan.CancellationInfo.Reason.rearrangementNeeded
        let view = LessonPlanCancellationView.ReasonView { reason in
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
}
