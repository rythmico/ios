import XCTest
@testable import Rythmico

final class LessonsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testInitialState() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success(.stub))

        let view = try XCTUnwrap(LessonsView())

        XCTAssertTrue(view.lessonPlans.isEmpty)
        XCTAssertFalse(view.isLoading)
        XCTAssertNil(view.errorMessage)
    }

    func testLessonPlansLoadingOnAppear() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success(.stub), delay: 0)

        let view = try XCTUnwrap(LessonsView())

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertTrue(view.isLoading)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLessonPlansFetching() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success(.stub))

        let view = try XCTUnwrap(LessonsView())

        XCTAssertView(view) { view in
            XCTAssertEqual(view.lessonPlans, .stub)
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLessonPlansFetchingFailure() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .failure("Something"))

        let view = try XCTUnwrap(LessonsView())

        XCTAssertView(view) { view in
            XCTAssertTrue(view.lessonPlans.isEmpty)
            XCTAssertFalse(view.isLoading)
            XCTAssertEqual(view.errorMessage, "Something")

            view.dismissErrorAlert()
            XCTAssertNil(view.errorMessage)
        }
    }

    func testPresentRequestLessonFlow() throws {
        let view = try XCTUnwrap(LessonsView())

        XCTAssertView(view) { view in
            XCTAssertNil(view.lessonRequestView)
            view.presentRequestLessonFlow()
            XCTAssertNotNil(view.lessonRequestView)
        }
    }
}
