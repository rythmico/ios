import XCTest
@testable import Rythmico

final class LessonsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testInitialState() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success(.stub))

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertTrue(view.lessonPlans.isEmpty)
        XCTAssertFalse(view.isLoading)
        XCTAssertNil(view.errorMessage)
    }

    func testLessonPlansLoadingOnAppear() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success(.stub), delay: 0)

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertTrue(view.isLoading)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLessonPlansFetching() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success(.stub))

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertView(view) { view in
            XCTAssertEqual(view.lessonPlans, .stub)
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLessonPlansFetchingFailure() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .failure("Something 1"))

        let fetchingCoordinator = try XCTUnwrap(Current.lessonPlanFetchingCoordinator())
        let view = try XCTUnwrap(LessonsView(coordinator: fetchingCoordinator))

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertFalse(view.isLoading)
            XCTAssertEqual(view.errorMessage, "Something 1")

            view.dismissErrorAlert()
            XCTAssertNil(view.errorMessage)
        }
    }
}
