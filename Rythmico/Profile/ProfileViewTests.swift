import XCTest
@testable import Rythmico
import Sugar

final class ProfileViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testInitialState() {
        let urlOpener = URLOpenerSpy()
        Current.urlOpener = urlOpener

        let deauthenticationSpy = DeauthenticationServiceSpy()
        Current.deauthenticationService = deauthenticationSpy

        let view = ProfileView()

        XCTAssertView(view) { view in
            XCTAssertEqual(urlOpener.openCount, 0)
            XCTAssertEqual(deauthenticationSpy.deauthenticationCount, 0)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testInitialState_pushNotificationsAuthorized() {
        let urlOpener = URLOpenerSpy()
        Current.urlOpener = urlOpener

        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: .authorized,
                authorizationRequestResult: (false, nil)
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )

        let view = ProfileView()

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNil(view.enablePushNotificationsAction)
            view.goToPushNotificationsSettingsAction?()
            XCTAssertEqual(urlOpener.openCount, 1)
        }
    }

    func testInitialState_pushNotificationsDenied() {
        let urlOpener = URLOpenerSpy()
        Current.urlOpener = urlOpener

        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: .denied,
                authorizationRequestResult: (false, nil)
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )

        let view = ProfileView()

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNil(view.enablePushNotificationsAction)
            view.goToPushNotificationsSettingsAction?()
            XCTAssertEqual(urlOpener.openCount, 1)
        }
    }

    func testPushNotificationRegistration_successAllowed() {
        let urlOpener = URLOpenerSpy()
        Current.urlOpener = urlOpener

        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: .notDetermined,
                authorizationRequestResult: (true, nil)
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )

        let view = ProfileView()

        XCTAssertView(view) { view in
            XCTAssertNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNotNil(view.enablePushNotificationsAction)
            view.enablePushNotificationsAction?()
            XCTAssertNotNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNil(view.enablePushNotificationsAction)
            view.goToPushNotificationsSettingsAction?()
            XCTAssertEqual(urlOpener.openCount, 1)
        }
    }

    func testPushNotificationRegistration_successDenied() {
        let urlOpener = URLOpenerSpy()
        Current.urlOpener = urlOpener

        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: .notDetermined,
                authorizationRequestResult: (false, nil)
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )

        let view = ProfileView()

        XCTAssertView(view) { view in
            XCTAssertNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNotNil(view.enablePushNotificationsAction)
            view.enablePushNotificationsAction?()
            XCTAssertNotNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNil(view.enablePushNotificationsAction)
            view.goToPushNotificationsSettingsAction?()
            XCTAssertEqual(urlOpener.openCount, 1)
        }
    }

    func testPushNotificationRegistration_failure() {
        let urlOpener = URLOpenerSpy()
        Current.urlOpener = urlOpener

        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: .notDetermined,
                authorizationRequestResult: (false, "something")
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )

        let view = ProfileView()

        XCTAssertView(view) { view in
            XCTAssertNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNotNil(view.enablePushNotificationsAction)
            view.enablePushNotificationsAction?()
            XCTAssertNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNotNil(view.enablePushNotificationsAction)
            XCTAssertEqual(view.errorMessage, "something")

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }

    func testLogOut() {
        let deauthenticationSpy = DeauthenticationServiceSpy()
        Current.deauthenticationService = deauthenticationSpy

        let view = ProfileView()

        XCTAssertView(view) { view in
            view.logOut()
            XCTAssertEqual(deauthenticationSpy.deauthenticationCount, 1)
        }
    }
}
