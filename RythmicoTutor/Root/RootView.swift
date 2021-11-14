import SwiftUIEncore

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
            case .registration:
                TutorProfileStatusView()
            case .mainView:
                MainView()
            }
        }
        .testable(self)
        .onReceive(userCredentialProvider.$userCredential, perform: onUserCredentialChanged)
        .onAppear(perform: handleStateChanges)
    }

    private func onUserCredentialChanged(_ credential: UserCredential?) {
        if credential == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .durationMedium * 2) {
                // FIXME: this crashes
//                Current.bookingsRepository.reset()
//                Current.bookingRequestRepository.reset()
//                Current.bookingApplicationRepository.reset()
                Current.tabSelection.reset()
            }
            Current.apnsRegistrationService.unregisterForRemoteNotifications()
        } else {
            Current.apnsRegistrationService.registerForRemoteNotifications()
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
