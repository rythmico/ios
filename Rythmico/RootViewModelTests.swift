import XCTest
@testable import Rythmico
import AuthenticationServices

final class RootViewModelTests: XCTestCase {
    var onboardingViewModelDummy: OnboardingViewModel {
        OnboardingViewModel(
            appleAuthorizationService: AppleAuthorizationServiceDummy(),
            authenticationService: AuthenticationServiceDummy(),
            keychain: KeychainDummy(),
            dispatchQueue: nil
        )
    }

    func testInitialState() {
        let keychain = KeychainFake()
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .notFound)
        let credentialRevocationObserver = AppleAuthorizationCredentialRevocationObserverFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(expectedProvider: nil)
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let viewModel = RootViewModel(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationObserving: credentialRevocationObserver,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService,
            dispatchQueue: nil
        )

        XCTAssertNotNil(viewModel.viewData.onboardingView)
        XCTAssertNil(viewModel.viewData.mainTabView)
        XCTAssert(keychain.inMemoryStorage.isEmpty)
        XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
    }

    func testAuthenticationShowsMainTabView() {
        let keychain = KeychainFake()
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .notFound)
        let credentialRevocationObserver = AppleAuthorizationCredentialRevocationObserverFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(expectedProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let viewModel = RootViewModel(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationObserving: credentialRevocationObserver,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService,
            dispatchQueue: nil
        )

        keychain.appleAuthorizationUserId = "USER_ID"

        XCTAssertNil(viewModel.viewData.onboardingView)
        XCTAssertNotNil(viewModel.viewData.mainTabView)
        XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
    }

    func testDeauthorizationWhileClosedShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .revoked)
        let credentialRevocationObserver = AppleAuthorizationCredentialRevocationObserverFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(expectedProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let viewModel = RootViewModel(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationObserving: credentialRevocationObserver,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService,
            dispatchQueue: nil
        )

        XCTAssertNotNil(viewModel.viewData.onboardingView)
        XCTAssertNil(viewModel.viewData.mainTabView)
        XCTAssertNil(keychain.appleAuthorizationUserId)
        XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
    }

    func testDeauthorizationWhileOpenShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .authorized)
        let credentialRevocationObserver = AppleAuthorizationCredentialRevocationObserverFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(expectedProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let viewModel = RootViewModel(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationObserving: credentialRevocationObserver,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService,
            dispatchQueue: nil
        )

        credentialRevocationObserver.revocationHandler?()

        XCTAssertNotNil(viewModel.viewData.onboardingView)
        XCTAssertNil(viewModel.viewData.mainTabView)
        XCTAssertNil(keychain.appleAuthorizationUserId)
        XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
    }

    func testDeauthenticationByProviderShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .authorized)
        let credentialRevocationObserver = AppleAuthorizationCredentialRevocationObserverFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(expectedProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let viewModel = RootViewModel(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationObserving: credentialRevocationObserver,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService,
            dispatchQueue: nil
        )

        accessTokenProviderObserver.statusDidChangeHandler?(nil)

        XCTAssertNotNil(viewModel.viewData.onboardingView)
        XCTAssertNil(viewModel.viewData.mainTabView)
        XCTAssertNil(keychain.appleAuthorizationUserId)
        XCTAssertEqual(deauthenticationService.deauthenticationCount, 0)
    }

    func testDeauthenticationByUserShowsOnboardingView() {
        let keychain = KeychainFake()
        keychain.appleAuthorizationUserId = "USER_ID"
        let credentialStateProvider = AppleAuthorizationCredentialStateFetcherStub(expectedState: .authorized)
        let credentialRevocationObserver = AppleAuthorizationCredentialRevocationObserverFake()
        let accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(expectedProvider: AuthenticationAccessTokenProviderDummy())
        let deauthenticationService = DeauthenticationServiceSpy(accessTokenProviderObserver: accessTokenProviderObserver)

        let viewModel = RootViewModel(
            keychain: keychain,
            onboardingViewModel: onboardingViewModelDummy,
            authorizationCredentialStateProvider: credentialStateProvider,
            authorizationCredentialRevocationObserving: credentialRevocationObserver,
            authenticationAccessTokenProviderObserving: accessTokenProviderObserver,
            deauthenticationService: deauthenticationService,
            dispatchQueue: nil
        )

        deauthenticationService.deauthenticate()

        XCTAssertNotNil(viewModel.viewData.onboardingView)
        XCTAssertNil(viewModel.viewData.mainTabView)
        XCTAssertNil(keychain.appleAuthorizationUserId)
        XCTAssertEqual(deauthenticationService.deauthenticationCount, 1)
    }
}
