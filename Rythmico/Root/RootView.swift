import SwiftUI
import Sugar

extension RootView {
    enum UserState {
        case unauthenticated(OnboardingView)
        case authenticated(MainTabView)

        var onboardingView: OnboardingView? {
            guard case .unauthenticated(let onboardingView) = self else {
                return nil
            }
            return onboardingView
        }

        var mainTabView: MainTabView? {
            guard case .authenticated(let mainTabView) = self else {
                return nil
            }
            return mainTabView
        }
    }
}

struct RootView<AccessTokenProviderObserving>: View, TestableView where
    AccessTokenProviderObserving: AuthenticationAccessTokenProviderObserving
{
    private let keychain: KeychainProtocol
    private let onboardingViewModel: OnboardingViewModel
    private let authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    private let authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving
    @ObservedObject
    private var authenticationAccessTokenProviderObserving: AccessTokenProviderObserving
    private let deauthenticationService: DeauthenticationServiceProtocol

    var state: UserState {
        if let provider = authenticationAccessTokenProviderObserving.currentProvider {
            return .authenticated(MainTabView(accessTokenProvider: provider))
        } else {
            self.keychain.appleAuthorizationUserId = nil
            return .unauthenticated(OnboardingView(viewModel: self.onboardingViewModel))
        }
    }

    init(
        keychain: KeychainProtocol,
        onboardingViewModel: OnboardingViewModel,
        authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider,
        authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving,
        authenticationAccessTokenProviderObserving: AccessTokenProviderObserving,
        deauthenticationService: DeauthenticationServiceProtocol
    ) {
        self.keychain = keychain
        self.onboardingViewModel = onboardingViewModel
        self.authorizationCredentialStateProvider = authorizationCredentialStateProvider
        self.authorizationCredentialRevocationObserving = authorizationCredentialRevocationObserving
        self.authenticationAccessTokenProviderObserving = authenticationAccessTokenProviderObserving
        self.deauthenticationService = deauthenticationService
    }

    var didAppear: Handler<Self>?
    var body: some View {
        ZStack {
            state.onboardingView.zIndex(1).transition(.move(edge: .leading))
            state.mainTabView.zIndex(2).transition(.move(edge: .trailing))
        }
        .animation(.easeInOut(duration: .durationMedium), value: state.mainTabView != nil)
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: onAppear)
    }

    private func onAppear() {
        if let authorizationUserId = keychain.appleAuthorizationUserId {
            authorizationCredentialStateProvider.getCredentialState(forUserID: authorizationUserId) { state in
                switch state {
                case .revoked, .transferred:
                    self.deauthenticationService.deauthenticate()
                    self.keychain.appleAuthorizationUserId = nil
                case .authorized, .notFound:
                    break
                @unknown default:
                    break
                }
            }
        }

        authorizationCredentialRevocationObserving.revocationHandler = {
            self.deauthenticationService.deauthenticate()
            self.keychain.appleAuthorizationUserId = nil
        }
    }
}
