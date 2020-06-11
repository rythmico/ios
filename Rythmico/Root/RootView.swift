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
        if let mainTabView = MainTabView() {
            return .authenticated(mainTabView)
        } else {
            Current.keychain.appleAuthorizationUserId = nil
            return .unauthenticated(OnboardingView())
        }
    }

    var didAppear: Handler<Self>?
    var body: some View {
        ZStack {
            state.unauthenticatedValue.zIndex(1).transition(.move(edge: .leading))
            state.authenticatedValue.zIndex(2).transition(.move(edge: .trailing))
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: state.isAuthenticated)
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
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()

        Current.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
        Current.authenticationService = AuthenticationServiceStub(
            result: .success(AuthenticationAccessTokenProviderDummy()),
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
