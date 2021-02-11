import SwiftUI
import Sugar

struct RootView: View, TestableView {
    @StateObject var accessTokenProviderObserver = Current.accessTokenProviderObserver
    @StateObject var flow = RootViewFlow()

    let inspection = SelfInspection()
    var body: some View {
        FlowView(flow: flow) {
            switch $0 {
            case .onboarding:
                OnboardingView()
            case .tutorStatus:
                TutorStatusView()
            case .mainView:
                MainView()
            }
        }
        .testable(self)
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
            Current.settings.tutorVerified = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .durationMedium * 2) {
                // FIXME: this crashes
//                Current.bookingsRepository.reset()
//                Current.bookingRequestRepository.reset()
//                Current.bookingApplicationRepository.reset()
                Current.state.reset()
            }
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
