import XCTest
@testable import Tutor
import ViewInspector

extension MainView: Inspectable {}

final class MainViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    // TODO: upcoming - re-enable
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
