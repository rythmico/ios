import XCTest
@testable import Rythmico
import class AuthenticationServices.ASAuthorizationAppleIDProvider
import Sugar

final class AppleAuthorizationCredentialRevocationNotifierTests: XCTestCase {
    func testRevocationHandlerNotificationCenterProperlySetUpAndHandled() {
        let expectation = self.expectation(description: "Revocation handler called")

        let center = NotificationCenterSpy(returnedToken: 1)
        let observer = AppleAuthorizationCredentialRevocationNotifier(notificationCenter: center)

        XCTAssertNil(center.notificationName)
        XCTAssertNil(center.observerBlock)

        observer.revocationHandler = {
            expectation.fulfill()
        }
        XCTAssertEqual(center.notificationName, ASAuthorizationAppleIDProvider.credentialRevokedNotification)
        XCTAssertNotNil(center.observerBlock)

        center.observerBlock?(Notification(name: ASAuthorizationAppleIDProvider.credentialRevokedNotification))

        wait(for: [expectation], timeout: 1)
    }

    func testRevocationHandlerNotificationCenterNotOversubscribed() {
        let expectationA = self.expectation(description: "Revocation handler not called")
            expectationA.isInverted = true
        let expectationB = self.expectation(description: "Revocation handler called once")

        let center = NotificationCenterSpy(returnedToken: 1)
        let observer = AppleAuthorizationCredentialRevocationNotifier(notificationCenter: center)

        observer.revocationHandler = {
            expectationA.fulfill()
        }

        center.returnedToken = 2
        observer.revocationHandler = {
            expectationB.fulfill()
        }

        center.observerBlock?(Notification(name: ASAuthorizationAppleIDProvider.credentialRevokedNotification))

        wait(for: [expectationA, expectationB], timeout: 1)
    }
}

private final class NotificationCenterSpy: NotificationCenter {
    private(set) var notificationName: NSNotification.Name?
    private(set) var observerBlock: ((Notification) -> Void)?

    var returnedToken: Int

    init(returnedToken: Int) {
        self.returnedToken = returnedToken
    }

    override func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        notificationName = name
        observerBlock = block
        return NSNumber(value: returnedToken)
    }
}
