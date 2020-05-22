import XCTest
@testable import Rythmico
import Sugar

final class ProfileViewTests: XCTestCase {
    func profileView(
        notificationsInitialStatus: PushNotificationAuthorizationStatus,
        notificationsRegistrationResult: SimpleResult<Bool>
    ) -> (URLOpenerSpy, DeauthenticationServiceSpy, ProfileView) {
        let urlOpener = URLOpenerSpy()
        let deauthenticationService = DeauthenticationServiceSpy(
            accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverStub(currentProvider: nil)
        )
        return (
            urlOpener,
            deauthenticationService,
            ProfileView(
                notificationsAuthorizationManager: PushNotificationAuthorizationManagerStub(
                    status: notificationsInitialStatus,
                    requestAuthorizationResult: notificationsRegistrationResult
                ),
                urlOpener: urlOpener,
                deauthenticationService: deauthenticationService
            )
        )
    }

    func testInitialState() {
        let (urlOpener, deauthenticationSpy, view) = profileView(
            notificationsInitialStatus: .notDetermined,
            notificationsRegistrationResult: .success(true)
        )

        XCTAssertView(view) { view in
            XCTAssertEqual(urlOpener.openCount, 0)
            XCTAssertEqual(deauthenticationSpy.deauthenticationCount, 0)
            XCTAssertNil(view.errorMessage)
        }
    }

    func testInitialState_pushNotificationsAuthorized() {
        let (urlOpener, _, view) = profileView(
            notificationsInitialStatus: .authorized,
            notificationsRegistrationResult: .success(true)
        )

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNil(view.enablePushNotificationsAction)
            view.goToPushNotificationsSettingsAction?()
            XCTAssertEqual(urlOpener.openCount, 1)
        }
    }

    func testInitialState_pushNotificationsDenied() {
        let (urlOpener, _, view) = profileView(
            notificationsInitialStatus: .denied,
            notificationsRegistrationResult: .success(true)
        )

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNil(view.enablePushNotificationsAction)
            view.goToPushNotificationsSettingsAction?()
            XCTAssertEqual(urlOpener.openCount, 1)
        }
    }

    func testPushNotificationRegistration_successAllowed() {
        let (urlOpener, _, view) = profileView(
            notificationsInitialStatus: .notDetermined,
            notificationsRegistrationResult: .success(true)
        )

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
        let (urlOpener, _, view) = profileView(
            notificationsInitialStatus: .notDetermined,
            notificationsRegistrationResult: .success(false)
        )

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
        let (_, _, view) = profileView(
            notificationsInitialStatus: .notDetermined,
            notificationsRegistrationResult: .failure("something")
        )

        XCTAssertView(view) { view in
            XCTAssertNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNotNil(view.enablePushNotificationsAction)
            view.enablePushNotificationsAction?()
            XCTAssertNil(view.goToPushNotificationsSettingsAction)
            XCTAssertNotNil(view.enablePushNotificationsAction)
            XCTAssertEqual(view.errorMessage, "something")
        }
    }

    func testLogOut() {
        let (_, deauthenticationSpy, view) = profileView(
            notificationsInitialStatus: .notDetermined,
            notificationsRegistrationResult: .failure("something")
        )

        XCTAssertView(view) { view in
            view.logOut()
            XCTAssertEqual(deauthenticationSpy.deauthenticationCount, 1)
        }
    }
}
