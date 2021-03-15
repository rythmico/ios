import XCTest
@testable import Rythmico
import ViewInspector

extension LessonsView: Inspectable {}

final class LessonsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testInitialState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success(.stub))

        let view = LessonsView()

        XCTAssertTrue(view.lessonPlans.isEmpty)
        XCTAssertFalse(view.isLoading)
        XCTAssertNil(view.error)
    }

    func testLessonPlansLoadingOnAppear() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success(.stub), delay: 0)

        let view = LessonsView()

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertTrue(view.isLoading)
            XCTAssertNil(view.error)
        }
    }

    func testLessonPlansFetching() throws {
        let spy = APIServiceSpy<GetLessonPlansRequest>(result: .success(.stub))
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, service: spy)

        let view = LessonsView()

        XCTAssertView(view) { view in
            XCTAssertEqual(view.lessonPlans, .stub)
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.error)
        }
    }

    func testLessonPlansFetchingFailure() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .failure("Something 1"))

        let view = LessonsView()

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertFalse(view.isLoading)
            XCTAssertEqual(view.error?.localizedDescription, "Something 1")
        }
    }
}
