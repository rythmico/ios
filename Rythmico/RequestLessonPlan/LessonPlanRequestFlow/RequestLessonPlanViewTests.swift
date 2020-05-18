import XCTest
@testable import Rythmico
import struct SwiftUI.Image

final class RequestLessonPlanViewTests: XCTestCase {
    func requestLessonPlanView(
        state: RequestLessonPlanCoordinatorState,
        context: RequestLessonPlanContext
    ) -> (RequestLessonPlanView) {
        let coordinator = RequestLessonPlanCoordinatorDummy()
        coordinator.state = state
        let view = RequestLessonPlanView(
            coordinator: coordinator,
            context: context,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            instrumentProvider: InstrumentSelectionListProviderFake(),
            keyboardDismisser: KeyboardDismisserSpy(),
            notificationsAuthorizationManager: PushNotificationAuthorizationManagerDummy()
        )
        return (view)
    }

    func testIdleState() {
        let (view) = requestLessonPlanView(state: .idle, context: .init())

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertTrue(view.swipeDownToDismissEnabled)
        }
    }

    func testLoadingState() {
        let (view) = requestLessonPlanView(state: .loading, context: .init())

        XCTAssertView(view) { view in
            XCTAssertNil(view.formView)
            XCTAssertNotNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
        }
    }

    func testFailureState() {
        let (view) = requestLessonPlanView(state: .failure("error"), context: .init())

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
        }
    }

    func testConfirmationState() {
        let (view) = requestLessonPlanView(state: .success(.stub), context: .init())

        XCTAssertView(view) { view in
            XCTAssertNil(view.formView)
            XCTAssertNil(view.loadingView)
            XCTAssertNotNil(view.confirmationView)
            XCTAssertFalse(view.swipeDownToDismissEnabled)
        }
    }
}
