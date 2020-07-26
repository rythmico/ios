import XCTest
@testable import Rythmico

final class LessonsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testInitialState() throws {
        Current.lessonPlanFetchingService = APIServiceStub(result: .success(.stub))

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertTrue(view.lessonPlans.isEmpty)
        XCTAssertFalse(view.isLoading)
        XCTAssertNil(view.error)
    }

    func testLessonPlansLoadingOnAppear() throws {
        Current.lessonPlanFetchingService = APIServiceStub(result: .success(.stub), delay: 0)

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertTrue(view.isLoading)
            XCTAssertNil(view.error)
        }
    }

    func testLessonPlansFetching() throws {
        let expectation = self.expectation(description: "Fetching")

        let spy = APIServiceSpy<GetLessonPlansRequest>(result: .success(.stub))
        Current.lessonPlanFetchingService = spy

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertView(view) { view in
            DispatchQueue.main.async {
                XCTAssertEqual(view.lessonPlans, .stub)
                expectation.fulfill()
            }
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.error)
        }

        wait(for: [expectation], timeout: 1)
    }

    func testLessonPlansFetchingFailure() throws {
        Current.lessonPlanFetchingService = APIServiceStub(result: .failure("Something 1"))

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertFalse(view.isLoading)
            XCTAssertEqual(view.error?.localizedDescription, "Something 1")
        }
    }
}
