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

    @State
    private(set) var state = Self.freshState

    var didAppear: Handler<Self>?
    var body: some View {
        ZStack {
            state.unauthenticatedValue.zIndex(1).transition(.move(edge: .leading))
            state.authenticatedValue.zIndex(2).transition(.move(edge: .trailing))
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: state.isAuthenticated)
        .onReceive(accessTokenProviderObserver.$currentProvider.receive(on: RunLoop.main), perform: refreshState)
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: onAppear)
    }

    private func onAppear() {
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

    private func refreshState(with provider: AuthenticationAccessTokenProvider?) {
        if provider == nil {
            // TODO: potentially refactor to put all-things-authentication into coordinator
            // that takes care of flushing keychain upon logout etc.
            Current.keychain.appleAuthorizationUserId = nil
        }

        let freshState = Self.freshState
        switch (freshState, self.state) {
        case (.authenticated, .unauthenticated), (.unauthenticated, .authenticated):
            self.state = freshState
        default:
            break
        }
    }

    private static var freshState: UserState {
        MainTabView().flatMap(UserState.authenticated) ?? .unauthenticated(OnboardingView())
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()

        Current.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
        Current.authenticationService = AuthenticationServiceStub(
            result: .success(AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN"))),
            delay: 2,
            accessTokenProviderObserver: Current.accessTokenProviderObserver
        )
        Current.deauthenticationService = DeauthenticationServiceStub(
            accessTokenProviderObserver: Current.accessTokenProviderObserver
        )

        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(
            result: .success([.stub]),
            delay: 2
        )

        return RootView()
    }
}
