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
    private let appleAuthorizationService: AppleAuthorizationServiceProtocol
    private let authenticationService: AuthenticationServiceProtocol
    private let authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    private let authorizationCredentialRevocationNotifying: AppleAuthorizationCredentialRevocationNotifying
    @ObservedObject
    private var authenticationAccessTokenProviderObserving: AccessTokenProviderObserving
    private let deauthenticationService: DeauthenticationServiceProtocol

    var state: UserState {
        if let provider = authenticationAccessTokenProviderObserving.currentProvider {
            return .authenticated(MainTabView(accessTokenProvider: provider))
        } else {
            self.keychain.appleAuthorizationUserId = nil
            return .unauthenticated(onboardingView)
        }
    }

    private var onboardingView: OnboardingView {
        OnboardingView(
            appleAuthorizationService: appleAuthorizationService,
            authenticationService: authenticationService,
            keychain: keychain
        )
    }

    init(
        keychain: KeychainProtocol,
        appleAuthorizationService: AppleAuthorizationServiceProtocol,
        authenticationService: AuthenticationServiceProtocol,
        authorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider,
        authorizationCredentialRevocationNotifying: AppleAuthorizationCredentialRevocationNotifying,
        authenticationAccessTokenProviderObserving: AccessTokenProviderObserving,
        deauthenticationService: DeauthenticationServiceProtocol
    ) {
        self.keychain = keychain
        self.appleAuthorizationService = appleAuthorizationService
        self.authenticationService = authenticationService
        self.authorizationCredentialStateProvider = authorizationCredentialStateProvider
        self.authorizationCredentialRevocationNotifying = authorizationCredentialRevocationNotifying
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

        authorizationCredentialRevocationNotifying.revocationHandler = {
            self.deauthenticationService.deauthenticate()
            self.keychain.appleAuthorizationUserId = nil
        }
    }
}
