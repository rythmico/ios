import XCTest
@testable import Rythmico
import enum UserNotifications.UNAuthorizationStatus
import Sugar
import ViewInspector

extension LessonPlanConfirmationView: Inspectable {}

final class LessonPlanConfirmationViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func confirmationView() -> LessonPlanConfirmationView {
        LessonPlanConfirmationView(lessonPlan: .pendingJackGuitarPlanStub)
    }

    func testEnableNotificationsButtonShown_whenStatusNotDetermined() {
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (true, nil)
        )

        XCTAssertView(confirmationView()) { view in
            XCTAssertNotNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotificationsButtonShown_whenStatusDenied() {
        Current.pushNotificationAuthorization(
            initialStatus: .denied,
            requestResult: (true, nil)
        )

        XCTAssertView(confirmationView()) { view in
            XCTAssertNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotificationsButtonShown_whenStatusAuthorized() {
        Current.pushNotificationAuthorization(
            initialStatus: .authorized,
            requestResult: (true, nil)
        )

        XCTAssertView(confirmationView()) { view in
            XCTAssertNil(view.enablePushNotificationsButtonAction)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testEnableNotifications_authorized() {
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (true, nil)
        )

        XCTAssertView(confirmationView()) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNil(view.enablePushNotificationsButtonAction)
        }
    }

    func testEnableNotifications_denied() {
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (false, nil)
        )

        XCTAssertView(confirmationView()) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNil(view.enablePushNotificationsButtonAction)
        }
    }

    func testEnableNotifications_failure() {
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (false, "Something 3")
        )

        XCTAssertView(confirmationView()) { view in
            view.enablePushNotificationsButtonAction?()
            XCTAssertNotNil(view.enablePushNotificationsButtonAction)
            XCTAssertEqual(view.errorMessage, "Something 3")

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }
}
