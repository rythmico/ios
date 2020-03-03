import XCTest
@testable import Rythmico
import AuthenticationServices

final class RootViewTests: XCTestCase {
    var onboardingViewModelDummy: OnboardingViewModel {
        OnboardingViewModel(
            appleAuthorizationService: AppleAuthorizationServiceDummy(),
            authenticationService: AuthenticationServiceDummy(),
            keychain: KeychainDummy()
        )
    }

    func testInitialState() {
        let keychain = KeychainFake()
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .notFound)
        let credentialRevocationNotifier = AppleAuthorizationCredentialRevocationNotifierFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: nil)
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let view = RootView(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationNotifying: credentialRevocationNotifier,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService
        )

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.state.onboardingView)
            XCTAssertNil(view.state.mainTabView)
            XCTAssert(keychain.inMemoryStorage.isEmpty)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testAuthenticationShowsMainTabView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .notFound)
        let credentialRevocationNotifier = AppleAuthorizationCredentialRevocationNotifierFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let view = RootView(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationNotifying: credentialRevocationNotifier,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService
        )

        XCTAssertView(view) { view in
            XCTAssertNil(view.state.onboardingView)
            XCTAssertNotNil(view.state.mainTabView)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testDeauthorizationWhileClosedShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .revoked)
        let credentialRevocationNotifier = AppleAuthorizationCredentialRevocationNotifierFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let view = RootView(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationNotifying: credentialRevocationNotifier,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService
        )

        XCTAssertView(view) { view in
            XCTAssertNotNil(view.state.onboardingView)
            XCTAssertNil(view.state.mainTabView)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }
    }

    func testDeauthorizationWhileOpenShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .authorized)
        let credentialRevocationNotifier = AppleAuthorizationCredentialRevocationNotifierFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let view = RootView(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationNotifying: credentialRevocationNotifier,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService
        )

        XCTAssertView(view) { view in
            credentialRevocationNotifier.revocationHandler?()
            XCTAssertNotNil(view.state.onboardingView)
            XCTAssertNil(view.state.mainTabView)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }
    }

    func testDeauthenticationByProviderShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .authorized)
        let credentialRevocationNotifier = AppleAuthorizationCredentialRevocationNotifierFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let view = RootView(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationNotifying: credentialRevocationNotifier,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService
        )

        XCTAssertView(view) { view in
            accessTokenProviderObserver.currentProvider = nil
            XCTAssertNotNil(view.state.onboardingView)
            XCTAssertNil(view.state.mainTabView)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
        }
    }

    func testDeauthenticationByUserShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .authorized)
        let credentialRevocationNotifier = AppleAuthorizationCredentialRevocationNotifierFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let view = RootView(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationNotifying: credentialRevocationNotifier,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService
        )

        XCTAssertView(view) { view in
            deauthenticationService.deauthenticate()
            XCTAssertNotNil(view.state.onboardingView)
            XCTAssertNil(view.state.mainTabView)
            XCTAssertNil(keychain.appleAuthorizationUserId)
            XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
        }
    }
}
