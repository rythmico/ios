import XCTest
@testable import Rythmico
import enum UserNotifications.UNAuthorizationStatus
import Sugar

final class RequestLessonPlanConfirmationViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func confirmationView(
        authorizationStatus: UNAuthorizationStatus,
        authorizationRequestResult: (Bool, Error?)
    ) -> RequestLessonPlanConfirmationView {
        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: authorizationStatus,
                authorizationRequestResult: authorizationRequestResult
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )
        return RequestLessonPlanConfirmationView(lessonPlan: .jackGuitarPlanStub)
    }

    func testEnableNotificationsButtonShown_whenStatusNotDetermined() {
        let view = confirmationView(
            authorizationStatus: .notDetermined,
            authorizationRequestResult: (true, nil)
        )

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotificationsButtonShown_whenStatusDenied() {
        let view = confirmationView(
            authorizationStatus: .denied,
            authorizationRequestResult: (true, nil)
        )

        XCTAssertView(view) { view in
            XCTAssertNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotificationsButtonShown_whenStatusAuthorized() {
        let view = confirmationView(
            authorizationStatus: .authorized,
            authorizationRequestResult: (true, nil)
        )

        XCTAssertView(view) { view in
            XCTAssertNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotifications_authorized() {
        let view = confirmationView(
            authorizationStatus: .notDetermined,
            authorizationRequestResult: (true, nil)
        )

        XCTAssertView(view) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNil(view.enablePushNotificationsButtonAction)
        }
    }

    func testEnableNotifications_denied() {
        let view = confirmationView(
            authorizationStatus: .notDetermined,
            authorizationRequestResult: (false, nil)
        )

        XCTAssertView(view) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNil(view.enablePushNotificationsButtonAction)
        }
    }

    func testEnableNotifications_failure() {
        let view = confirmationView(
            authorizationStatus: .notDetermined,
            authorizationRequestResult: (false, "Something 3")
        )

        XCTAssertView(view) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNotNil(view.enablePushNotificationsButtonAction)
            XCTAssertEqual(view.errorMessage, "Something 3")

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }
}
