import XCTest
@testable import Rythmico
import AuthenticationServices

final class RootViewTests: XCTestCase {
    func rootView(
        appleAuthorizationUserId: String?,
        credentialState: AppleAuthorizationCredentialStateFetcher.CredentialState,
        accessTokenProvider: AuthenticationAccessTokenProvider?
    ) -> (
        KeychainFake,
        AppleAuthorizationCredentialRevocationNotifierFake,
        AuthenticationAccessTokenProviderObserverStub,
        DeauthenticationServiceSpy,
        RootView<AuthenticationAccessTokenProviderObserverStub>
    ) {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = appleAuthorizationUserId
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: credentialState)
        let credentialRevocationNotifier = AppleAuthorizationCredentialRevocationNotifierFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: accessTokenProvider)
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let view = RootView(
            keychain: keychain,
            appleAuthorizationService: AppleAuthorizationServiceDummy(),
            authenticationService: AuthenticationServiceDummy(),
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationNotifying: credentialRevocationNotifier,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService
        )

        return (keychain, credentialRevocationNotifier, accessTokenProviderObserver, deauthenticationService, view)
    }

    func testInitialState() {
        let (keychain, _, _, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: nil,
            credentialState: .notFound,
            accessTokenProvider: nil
        )

        XCTAssertView(view) { view in
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            XCTAssert(keychain.inMemoryStorage.isEmpty)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testAuthenticationShowsMainTabView() {
        let (_, _, _, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .notFound,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy()
        )

        XCTAssertView(view) { view in
            XCTAssertFalse(view.state.isUnauthenticated)
            XCTAssertTrue(view.state.isAuthenticated)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testDeauthorizationWhileClosedShowsOnboardingView() {
        let (keychain, _, _, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .revoked,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy()
        )

        XCTAssertView(view) { view in
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }
    }

    func testDeauthorizationWhileOpenShowsOnboardingView() {
        let (keychain, credentialRevocationNotifier, _, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .authorized,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy()
        )

        XCTAssertView(view) { view in
            credentialRevocationNotifier.revocationHandler?()
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }
    }

    func testDeauthenticationByProviderShowsOnboardingView() {
        let (keychain, _, accessTokenProviderObserver, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .authorized,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy()
        )

        XCTAssertView(view) { view in
            accessTokenProviderObserver.currentProvider = nil
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testDeauthenticationByUserShowsOnboardingView() {
        let (keychain, _, _, deauthenticationService, view) = rootView(
            appleAuthorizationUserId: "USER_ID",
            credentialState: .authorized,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy()
        )

        XCTAssertView(view) { view in
            deauthenticationService.deauthenticate()
            XCTAssertTrue(view.state.isUnauthenticated)
            XCTAssertFalse(view.state.isAuthenticated)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }
    }
}
