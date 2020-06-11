import XCTest
@testable import Rythmico

final class MainTabViewTests: XCTestCase {
    func testPushNotificationRegistrationOnAppear() {
        let spy = DeviceRegisterServiceSpy()
        let view = MainTabView(
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            lessonPlanRepository: LessonPlanRepository(),
            pushNotificationRegistrationService: spy,
            pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerDummy(),
            deauthenticationService: DeauthenticationServiceDummy()
        )

        XCTAssertView(view) { view in
            XCTAssertEqual(spy.registerCount, 1)
        }
    }
}
