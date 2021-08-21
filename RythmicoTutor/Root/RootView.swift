import SwiftUISugar

struct RootView: View, TestableView {
    @ObservedObject
    var userCredentialProvider = Current.userCredentialProvider
    @StateObject
    var flow: RootViewFlow

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
        .onReceive(userCredentialProvider.$userCredential, perform: onUserCredentialChanged)
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

    private func onUserCredentialChanged(_ credential: UserCredentialProtocol?) {
        if credential == nil {
            // TODO: potentially refactor to put all-things-authentication into coordinator
            // that takes care of flushing keychain upon logout etc.
            Current.keychain.appleAuthorizationUserId = nil
            Current.settings.tutorVerified = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .durationMedium * 2) {
                // FIXME: this crashes
//                Current.bookingsRepository.reset()
//                Current.bookingRequestRepository.reset()
//                Current.bookingApplicationRepository.reset()
                Current.tabSelection.reset()
            }
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(flow: RootViewFlow()).previewDevices()
    }
}
#endif
