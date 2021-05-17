import XCTest
@testable import Rythmico
import ViewInspector

extension LessonPlanDetailView: Inspectable {}

final class LessonPlanDetailViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testCancellationFormPresentation() {}
}
