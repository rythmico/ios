import XCTest
@testable import Auth
import class AuthenticationServices.ASAuthorizationAppleIDProvider
import Sugar

final class AppleAuthorizationCredentialRevocationObserverTests: XCTestCase {
    func testRevocationHandlerNotificationCenterProperlySetUpAndHandled() {
        let expectation = self.expectation(description: "Revocation handler called")

        let center = NotificationCenterSpy(returnedToken: 1)
        let observer = AppleAuthorizationCredentialRevocationObserver(notificationCenter: center)

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
        let observer = AppleAuthorizationCredentialRevocationObserver(notificationCenter: center)

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
