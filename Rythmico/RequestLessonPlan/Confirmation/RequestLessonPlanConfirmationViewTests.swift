import XCTest
@testable import Rythmico
import Sugar

final class RequestLessonPlanConfirmationViewTests: XCTestCase {
    func confirmationView(
        notificationsStatus: PushNotificationAuthorizationStatus,
        requestAuthorizationResult: SimpleResult<Bool>
    ) -> (PushNotificationAuthorizationManagerStub, RequestLessonPlanConfirmationView) {
        let notificationsAuthorizationManager = PushNotificationAuthorizationManagerStub(
            status: notificationsStatus,
            requestAuthorizationResult: requestAuthorizationResult
        )
        return (
            notificationsAuthorizationManager,
            RequestLessonPlanConfirmationView(
                lessonPlan: .stub,
                notificationsAuthorizationManager: notificationsAuthorizationManager
            )
        )
    }

    func testEnableNotificationsButtonShown_whenStatusNotDetermined() {
        let (_, view) = confirmationView(
            notificationsStatus: .notDetermined,
            requestAuthorizationResult: .success(true)
        )

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotificationsButtonShown_whenStatusDenied() {
        let (_, view) = confirmationView(
            notificationsStatus: .denied,
            requestAuthorizationResult: .success(true)
        )

        XCTAssertView(view) { view in
            XCTAssertNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotificationsButtonShown_whenStatusAuthorized() {
        let (_, view) = confirmationView(
            notificationsStatus: .authorized,
            requestAuthorizationResult: .success(true)
        )

        XCTAssertView(view) { view in
            XCTAssertNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotifications_authorized() {
        let (_, view) = confirmationView(
            notificationsStatus: .notDetermined,
            requestAuthorizationResult: .success(true)
        )

        XCTAssertView(view) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNil(view.enablePushNotificationsButtonAction)
        }
    }

    func testEnableNotifications_denied() {
        let (_, view) = confirmationView(
            notificationsStatus: .notDetermined,
            requestAuthorizationResult: .success(false)
        )

        XCTAssertView(view) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNil(view.enablePushNotificationsButtonAction)
        }
    }

    func testEnableNotifications_failure() {
        let (_, view) = confirmationView(
            notificationsStatus: .notDetermined,
            requestAuthorizationResult: .failure("error")
        )

        XCTAssertView(view) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNotNil(view.enablePushNotificationsButtonAction)
        }
    }
}
