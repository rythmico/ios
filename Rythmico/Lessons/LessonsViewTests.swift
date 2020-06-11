import XCTest
@testable import Rythmico

final class LessonsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testInitialState() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success([.stub]))

        let _ = try XCTUnwrap(LessonsView())

        XCTAssertEqual(Current.lessonPlanRepository.lessonPlans, [])
    }

    func testLessonPlansLoadingOnAppear() throws {
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success([.stub]))

        let view = try XCTUnwrap(LessonsView())

        XCTAssertView(view) { view in
            XCTAssertEqual(Current.lessonPlanRepository.lessonPlans, [.stub])
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
