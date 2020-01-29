import Foundation
import Combine
import Auth

protocol RootViewModelProtocol: ViewModel where ViewData == RootViewData {}

final class RootViewModel: RootViewModelProtocol {
    let objectWillChange = ObservableObjectPublisher()

    private(set) var viewData: RootViewData {
        willSet { dispatchQueue?.async(execute: objectWillChange.send) ?? objectWillChange.send() }
    }

    private let authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    private let authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving
    private let authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserving
    private let dispatchQueue: DispatchQueue?

    init(
        keychain: KeychainProtocol,
        onboardingViewModel: OnboardingViewModel,
        authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider,
        authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving,
        authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserving,
        deauthenticationService: DeauthenticationServiceProtocol,
        dispatchQueue: DispatchQueue?
    ) {
        func viewData(for provider: AuthenticationAccessTokenProvider?) -> ViewData {
            if let provider = provider {
                return .authenticated(MainTabView(viewModel: MainTabViewModel(accessTokenProvider: provider)))
            } else {
                return .unauthenticated(OnboardingView(viewModel: onboardingViewModel))
            }
        }

        self.viewData = viewData(for: nil)
        self.authorizationCredentialStateProvider = authorizationCredentialStateProvider
        self.authorizationCredentialRevocationObserving = authorizationCredentialRevocationObserving
        self.authenticationAccessTokenProviderObserving = authenticationAccessTokenProviderObserving
        self.dispatchQueue = dispatchQueue

        self.authenticationAccessTokenProviderObserving.statusDidChangeHandler = { provider in
            self.viewData = viewData(for: provider)
        }

        if let authorizationUserId = keychain.appleAuthorizationUserId {
            authorizationCredentialStateProvider.getCredentialState(forUserID: authorizationUserId) { state in
                switch state {
                case .revoked, .transferred:
                    deauthenticationService.deauthenticate()
                    keychain.appleAuthorizationUserId = nil
                case .authorized, .notFound:
                    break
                @unknown default:
                    break
                }
            }
        }

        authorizationCredentialRevocationObserving.revocationHandler = {
            deauthenticationService.deauthenticate()
            keychain.appleAuthorizationUserId = nil
        }
    }
}
