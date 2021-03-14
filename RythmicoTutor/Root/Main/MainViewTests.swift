import XCTest
@testable import Tutor
import ViewInspector

extension MainView: Inspectable {}

final class MainViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func testDeviceRegistrationOnAppear() throws {
        let spy = APIServiceSpy<AddDeviceRequest>()
        Current.deviceRegisterCoordinator = DeviceRegisterCoordinator(
            deviceTokenProvider: DeviceTokenProviderStub(result: .success("TOKEN")),
            apiCoordinator: Current.coordinator(for: spy)
        )

        let view = MainView()
        XCTAssertView(view) { view in
            XCTAssertEqual(spy.sendCount, 1)
        }
    }

    func testPushNotificationPromptOnAppear() throws {
        Current.stubAPIEndpoint(for: \.bookingsFetchingCoordinator, result: .success(.stub))
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (true, nil)
        )

        let view = MainView()
        XCTAssertTrue(Current.pushNotificationAuthorizationCoordinator.status.isNotDetermined)
        XCTAssertView(view) { view in
            XCTAssertTrue(Current.pushNotificationAuthorizationCoordinator.status.isAuthorized)
        }
    }
}
