import XCTest
@testable import Tutor
import ViewInspector

extension MainTabView: Inspectable {}

final class MainTabViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testDeviceRegistrationOnAppear() throws {
        Current.deviceTokenProvider = DeviceTokenProviderStub(result: .success("TOKEN"))

        let spy = APIServiceSpy<AddDeviceRequest>()
        Current.deviceRegisterService = spy

        let view = try XCTUnwrap(MainTabView())

        XCTAssertView(view) { view in
            XCTAssertEqual(spy.sendCount, 1)
        }
    }

    func testPushNotificationPromptOnAppear() throws {
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (true, nil)
        )

        let view = try XCTUnwrap(MainTabView())

        XCTAssertTrue(Current.pushNotificationAuthorizationCoordinator.status.isNotDetermined)

        XCTAssertView(view) { view in
            XCTAssertTrue(Current.pushNotificationAuthorizationCoordinator.status.isAuthorized)
        }
    }
}
