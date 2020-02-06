import Foundation
@testable import ViewModel

final class RootViewModel: ViewModelObject<RootViewData> {
    private let authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    private let authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving
    private let authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserving

    init(
        keychain: KeychainProtocol,
        onboardingViewModel: OnboardingViewModel,
        authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider,
        authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving,
        authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserving,
        deauthenticationService: DeauthenticationServiceProtocol
    ) {
        func viewData(for provider: AuthenticationAccessTokenProvider?) -> ViewData {
            if let provider = provider {
                return .authenticated(MainTabView(viewModel: MainTabViewModel(accessTokenProvider: provider)))
            } else {
                return .unauthenticated(OnboardingView(viewModel: onboardingViewModel))
            }
        }

        self.authorizationCredentialStateProvider = authorizationCredentialStateProvider
        self.authorizationCredentialRevocationObserving = authorizationCredentialRevocationObserving
        self.authenticationAccessTokenProviderObserving = authenticationAccessTokenProviderObserving
        super.init(viewData: viewData(for: nil))

        self.authenticationAccessTokenProviderObserving.statusDidChangeHandler = { provider in
            if provider == nil {
                keychain.appleAuthorizationUserId = nil
            }
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
