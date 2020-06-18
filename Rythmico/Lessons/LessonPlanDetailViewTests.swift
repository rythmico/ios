import XCTest
@testable import Rythmico

final class LessonPlanDetailViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testCancellationFormPresentation() {
        let view = LessonPlanDetailView(.jackGuitarPlanStub)

        XCTAssertView(view) { view in
            XCTAssertNil(view.cancellationView)
            view.showCancelLessonPlanForm()
            XCTAssertNotNil(view.cancellationView)
        }
    }
}
