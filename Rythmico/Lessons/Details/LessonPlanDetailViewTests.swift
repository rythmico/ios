import XCTest
@testable import Rythmico
import ViewInspector

extension LessonPlanDetailView: Inspectable {}

final class LessonPlanDetailViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testCancellationFormPresentation() {
        let view = LessonPlanDetailView(lessonPlan: .pendingJackGuitarPlanStub)

        XCTAssertView(view) { view in
            XCTAssertEqual(Current.state.lessonsContext, .none)
            view.showCancelLessonPlanForm()
            XCTAssertEqual(Current.state.lessonsContext, .viewingLessonPlan(.pendingJackGuitarPlanStub, isCancelling: true))
        }
    }
}
