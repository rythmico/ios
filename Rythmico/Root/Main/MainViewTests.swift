import XCTest
@testable import Rythmico
import ViewInspector

extension MainView: Inspectable {}

final class MainViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
        Current.stubAPIEndpoint(for: \.lessonPlanRequestFetchingCoordinator, result: .success([.stub]))
    }

    func testAutoPresentRequestLessonFlow() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestFetchingCoordinator, result: .success([]))

        let view = MainView()
        XCTAssertView(view) { view in
            XCTAssertTrue(Current.lessonsTabNavigation.path.current.is(LessonsScreen(), RequestLessonPlanScreen()))
        }
    }
}
