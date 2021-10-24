import XCTest
@testable import Rythmico
import ViewInspector

extension MainView: Inspectable {}

final class MainViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success([.pendingJackGuitarPlanStub]))
    }

    func testAutoPresentRequestLessonFlow() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success([]))

        let view = MainView()
        XCTAssertView(view) { view in
            XCTAssertTrue(Current.lessonsTabNavigation.path.current.is(LessonsScreen(), RequestLessonPlanScreen()))
        }
    }
}
