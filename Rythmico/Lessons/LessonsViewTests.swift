import XCTest
@testable import Rythmico

final class LessonsViewTests: XCTestCase {
    var lessonsView: (LessonPlanFetchingCoordinatorSpy, LessonPlanRepository, LessonsView) {
        let repository = LessonPlanRepository()
        let coordinator = LessonPlanFetchingCoordinatorSpy()
        return (
            coordinator,
            repository,
            LessonsView(
                accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
                pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerDummy(),
                lessonPlanFetchingCoordinator: coordinator,
                lessonPlanRepository: repository
            )
        )
    }

    func testInitialState() {
        let (coordinator, _, _) = lessonsView
        XCTAssertEqual(coordinator.fetchCount, 0)
        XCTAssertNil(coordinator.error)
    }

    func testLessonPlansLoadingOnAppear() {
        let (coordinator, _, view) = lessonsView

        XCTAssertView(view) { view in
            XCTAssertEqual(coordinator.fetchCount, 1)
        }
    }

    func testPresentRequestLessonFlow() {
        let (_, _, view) = lessonsView

        XCTAssertView(view) { view in
            XCTAssertNil(view.lessonRequestView)
            view.presentRequestLessonFlow()
            XCTAssertNotNil(view.lessonRequestView)
        }
    }
}
