import SwiftUI
import Sugar

extension RootView {
    enum UserState {
        case unauthenticated(OnboardingView)
        case authenticated(MainTabView)
    }
}

struct RootView: View, TestableView {
    @ObservedObject
    private var accessTokenProviderObserver = Current.accessTokenProviderObserver

    var state: UserState {
        MainTabView().flatMap(UserState.authenticated) ?? .unauthenticated(OnboardingView())
    }

    let inspection = SelfInspection()
    var body: some View {
        ZStack {
            state.unauthenticatedValue.zIndex(1).transition(.move(edge: .leading))
            state.authenticatedValue.zIndex(2).transition(.move(edge: .trailing))
        }
        .testable(self)
        .animation(.rythmicoSpring(duration: .durationMedium), value: state.isAuthenticated)
        .onReceive(accessTokenProviderObserver.$currentProvider, perform: accessTokenProviderChanged)
        .onAppear(perform: handleStateChanges)
    }

    private func handleStateChanges() {
        if let authorizationUserId = Current.keychain.appleAuthorizationUserId {
            Current.appleAuthorizationCredentialStateProvider.getCredentialState(forUserID: authorizationUserId) { state in
                switch state {
                case .revoked, .transferred:
                    Current.deauthenticationService.deauthenticate()
                    Current.keychain.appleAuthorizationUserId = nil
                case .authorized, .notFound:
                    break
                @unknown default:
                    break
                }
            }
        }

        Current.appleAuthorizationCredentialRevocationNotifier.revocationHandler = {
            Current.deauthenticationService.deauthenticate()
            Current.keychain.appleAuthorizationUserId = nil
        }
    }

    private func accessTokenProviderChanged(with provider: AuthenticationAccessTokenProvider?) {
        if provider == nil {
            // TODO: potentially refactor to put all-things-authentication into coordinator
            // that takes care of flushing keychain upon logout etc.
            Current.keychain.appleAuthorizationUserId = nil
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().previewDevices()
    }
}
#endif
