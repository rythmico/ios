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

struct RootView: View, TestableView {
    private let keychain: KeychainProtocol
    private let onboardingViewModel: OnboardingViewModel
    private let authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    private let authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving
    private let authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserving
    private let deauthenticationService: DeauthenticationServiceProtocol

    @State private(set) var state: UserState

    init(
        keychain: KeychainProtocol,
        onboardingViewModel: OnboardingViewModel,
        authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider,
        authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserving,
        authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserving,
        deauthenticationService: DeauthenticationServiceProtocol
    ) {
        self.keychain = keychain
        self.onboardingViewModel = onboardingViewModel
        self.authorizationCredentialStateProvider = authorizationCredentialStateProvider
        self.authorizationCredentialRevocationObserving = authorizationCredentialRevocationObserving
        self.authenticationAccessTokenProviderObserving = authenticationAccessTokenProviderObserving
        self.deauthenticationService = deauthenticationService

        self._state = State(initialValue: .unauthenticated(OnboardingView(viewModel: onboardingViewModel)))
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
        authenticationAccessTokenProviderObserving.statusDidChangeHandler = { provider in
            if let provider = provider {
                self.state = .authenticated(MainTabView(accessTokenProvider: provider))
            } else {
                self.keychain.appleAuthorizationUserId = nil
                self.state = .unauthenticated(OnboardingView(viewModel: self.onboardingViewModel))
            }
        }

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
