import XCTest
@testable import Rythmico

final class LessonsViewTests: XCTestCase {
    var lessonsView: (LessonPlanFetchingCoordinatorBase, LessonPlanRepository, LessonsView) {
        let repository = LessonPlanRepository()
        let coordinator = LessonPlanFetchingCoordinatorStub(result: .success([.stub, .stub, .stub]), repository: repository)
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

    func testPresentRequestLessonFlow() {
        let (_, _, view) = lessonsView

        XCTAssertView(view) { view in
            XCTAssertNil(view.lessonRequestView)
            view.presentRequestLessonFlow()
            XCTAssertNotNil(view.lessonRequestView)
        }
    }
}
