import FoundationEncore
@testable import Rythmico
import ViewInspector
import XCTest

extension LessonsView: Inspectable {}

final class LessonsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testInitialState() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestFetchingCoordinator, result: .success([.stub]))

        let view = LessonsView()

        XCTAssertTrue(view.repository.items.isEmpty)
        XCTAssertFalse(view.isLoading)
        XCTAssertNil(view.error)
    }

    func testLessonPlansLoadingOnAppear() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestFetchingCoordinator, result: .success([.stub]), delay: 0)

        let view = LessonsView()

        XCTAssertView(view) { view in
            XCTAssertTrue(view.repository.items.isEmpty)
            XCTAssertTrue(view.isLoading)
            XCTAssertNil(view.error)
        }
    }

    func testLessonPlansFetching() throws {
        let spy = APIServiceSpy<GetLessonPlanRequestsRequest>(result: .success([.stub]))
        Current.stubAPIEndpoint(for: \.lessonPlanRequestFetchingCoordinator, service: spy)

        let view = LessonsView()

        XCTAssertView(view) { view in
            XCTAssertEqual(view.repository.items, [.stub])
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.error)
        }
    }

    func testLessonPlansFetchingFailure() throws {
        Current.stubAPIEndpoint(for: \.lessonPlanRequestFetchingCoordinator, result: .failure(RuntimeError("Something 1")))

        let view = LessonsView()

        XCTAssertView(view) { view in
            XCTAssertTrue(view.repository.items.isEmpty)
            XCTAssertFalse(view.isLoading)
            XCTAssertEqual(view.error?.legibleLocalizedDescription, "Something 1")
        }
    }
}
