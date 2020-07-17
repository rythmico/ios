import XCTest
@testable import Rythmico
import AuthenticationServices

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
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(
            currentProvider: userAuthenticated ? AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN")) : nil
        )
        let deauthenticationService = DeauthenticationServiceSpy()

        Current.keychain = keychain
        Current.appleAuthorizationCredentialStateProvider = credentialStateProvider
        Current.accessTokenProviderObserver = accessTokenProviderObserver
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

    func testAuthenticationShowsMainTabView() {
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

    // TODO: re-enable when @StateObject can be attached to accessTokenProviderObserver
    // on RootView and state can be computed again (no need for next run loop check this way).
    func testDeauthorizationWhileClosedShowsOnboardingView() {
        let expectation = self.expectation(description: "Authentication")

        let (keychain, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .revoked,
            userAuthenticated: true
        )

        XCTAssertView(view) { view in
            DispatchQueue.main.async {
                XCTAssertTrue(view.state.isUnauthenticated)
                XCTAssertFalse(view.state.isAuthenticated)
                expectation.fulfill()
            }
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }

        wait(for: [expectation], timeout: 1)
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
            DispatchQueue.main.async {
                XCTAssertTrue(view.state.isUnauthenticated)
                XCTAssertFalse(view.state.isAuthenticated)
                expectation.fulfill()
            }
            XCTAssertNil(keychain.appleAuthorizationUserId)
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
            Current.accessTokenProviderObserver.currentProvider = nil
            DispatchQueue.main.async {
                XCTAssertTrue(view.state.isUnauthenticated)
                XCTAssertFalse(view.state.isAuthenticated)
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
            DispatchQueue.main.async {
                XCTAssertTrue(view.state.isUnauthenticated)
                XCTAssertFalse(view.state.isAuthenticated)
                XCTAssertNil(keychain.appleAuthorizationUserId)
                expectation.fulfill()
            }
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }

        wait(for: [expectation], timeout: 1)
    }
}
