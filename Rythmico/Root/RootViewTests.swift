import XCTest
@testable import Rythmico
import AuthenticationServices
import ViewInspector

extension RootView: Inspectable {}

final class RootViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
    }

    func rootView(
        appleAuthorizationUserId: String?,
        credentialState: AppleAuthorizationCredentialStateFetcher.CredentialState,
        userAuthenticated: Bool
    ) -> (
        KeychainFake,
        DeauthenticationServiceSpy,
        RootView
    ) {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = appleAuthorizationUserId
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: credentialState)
        if userAuthenticated {
            Current.userAuthenticated()
        } else {
            Current.userUnauthenticated()
        }
        let deauthenticationService = DeauthenticationServiceSpy()

        Current.keychain = keychain
        Current.appleAuthorizationCredentialStateProvider = credentialStateProvider
        Current.deauthenticationService = deauthenticationService

        return (keychain, deauthenticationService, RootView())
    }

    func testInitialState() {
        let (keychain, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: nil,
            credentialState: .notFound,
            userAuthenticated: false
        )

        XCTAssertView(view) { view in
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            XCTAssert(keychain.inMemoryStorage.isEmpty)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testAuthenticationShowsMainView() {
        let (_, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .notFound,
            userAuthenticated: true
        )

        XCTAssertView(view) { view in
            XCTAssertFalse(view.state.isUnauthenticated)
            XCTAssertTrue(view.state.isAuthenticated)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testDeauthorizationWhileClosedShowsOnboardingView() {
        let (keychain, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .revoked,
            userAuthenticated: true
        )

        XCTAssertView(view, after: 0.5) { view in
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 2)
        }
    }

    func testDeauthorizationWhileOpenShowsOnboardingView() {
        let expectation = self.expectation(description: "Authentication")

        let (keychain, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .authorized,
            userAuthenticated: true
        )

        XCTAssertView(view) { view in
            Current.appleAuthorizationCredentialRevocationNotifier.revocationHandler?()
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            DispatchQueue.main.async {
                XCTAssertNil(keychain.appleAuthorizationUserId)
                expectation.fulfill()
            }
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }

        wait(for: [expectation], timeout: 1)
    }

    func testDeauthenticationByProviderShowsOnboardingView() {
        let expectation = self.expectation(description: "Authentication")

        let (keychain, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .authorized,
            userAuthenticated: true
        )

        XCTAssertView(view) { view in
            Current.userCredentialProvider.userCredential = nil
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            DispatchQueue.main.async {
                XCTAssertNil(keychain.appleAuthorizationUserId)
                expectation.fulfill()
            }
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }

        wait(for: [expectation], timeout: 1)
    }

    func testDeauthenticationByUserShowsOnboardingView() {
        let expectation = self.expectation(description: "Authentication")

        let (keychain, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .authorized,
            userAuthenticated: true
        )

        XCTAssertView(view) { view in
            deauthenticationService.deauthenticate()
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            DispatchQueue.main.async {
                XCTAssertNil(keychain.appleAuthorizationUserId)
                expectation.fulfill()
            }
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }

        wait(for: [expectation], timeout: 1)
    }
}
