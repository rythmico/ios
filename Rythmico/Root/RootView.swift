import SwiftUI
import FoundationSugar

extension RootView {
    enum UserState {
        case unauthenticated(OnboardingView)
        case authenticated(MainView)
    }
}

struct RootView: View, TestableView {
    @StateObject
    private var accessTokenProviderObserver = Current.accessTokenProviderObserver

    var state: UserState {
        MainView().flatMap(UserState.authenticated) ?? .unauthenticated(OnboardingView())
    }

    let inspection = SelfInspection()
    var body: some View {
        RootViewContent(state: state)
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
                case .authorized, .notFound:
                    break
                @unknown default:
                    break
                }
            }
        }

        Current.appleAuthorizationCredentialRevocationNotifier.revocationHandler = {
            Current.deauthenticationService.deauthenticate()
        }
    }

    private func accessTokenProviderChanged(with provider: AuthenticationAccessTokenProvider?) {
        if provider == nil {
            // TODO: potentially refactor to put all-things-authentication into coordinator
            // that takes care of flushing keychain upon logout etc.
            Current.keychain.appleAuthorizationUserId = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + .durationMedium * 2) {
                Current.lessonPlanRepository.reset()
                Current.state.reset()
            }
        }
    }
}

struct RootViewContent: View {
    var state: RootView.UserState

    var body: some View {
        ZStack {
            state.unauthenticatedValue.zIndex(1).transition(.move(edge: .leading))
            state.authenticatedValue.zIndex(2).transition(.move(edge: .trailing))
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
