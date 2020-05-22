import XCTest
@testable import Rythmico

final class MainTabViewTests: XCTestCase {
    func testPushNotificationRegistrationOnAppear() {
        let spy = PushNotificationRegistrationServiceSpy()
        let view = MainTabView(
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            pushNotificationRegistrationService: spy,
            pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerDummy(),
            deauthenticationService: DeauthenticationServiceDummy()
        )

        XCTAssertView(view) { view in
            XCTAssertEqual(spy.registerCount, 1)
        }
    }

    func testPresentRequestLessonFlow() {
        let view = MainTabView(
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            pushNotificationRegistrationService: PushNotificationRegistrationServiceDummy(),
            pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerDummy(),
            deauthenticationService: DeauthenticationServiceDummy()
        )

        XCTAssertView(view) { view in
            XCTAssertNil(view.lessonRequestView)
            view.presentRequestLessonFlow()
            XCTAssertNotNil(view.lessonRequestView)
        }
    }
}
