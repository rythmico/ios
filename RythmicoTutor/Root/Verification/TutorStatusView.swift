import SwiftUIEncore

struct TutorStatusView: View {
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator
    @ObservedObject
    private var coordinator = Current.tutorStatusFetchingCoordinator
    @State
    private var currentStatus: TutorStatus?
    @StateObject
    private var webViewStore = WebViewStore()

    var body: some View {
        ZStack {
            if let status = currentStatus {
                switch status {
                case .registrationPending:
                    RythmicoWebView(store: webViewStore, ignoreBottomSafeArea: true, onDone: coordinator.run)
                case .interviewPending, .interviewFailed, .dbsPending, .dbsProcessing, .dbsFailed, .verified:
                    TutorStatusBanner(status: status)
                }
            }
            if isFetchingStatus {
                ActivityIndicator(color: .gray)
            }
        }
        .onAppear(perform: Current.deviceRegisterCoordinator.registerDevice)
        .onAppear(perform: coordinator.run)
        .onEvent(.appInForeground, perform: coordinator.run)
        .onSuccess(coordinator, perform: tutorStatusFetched)
        .alertOnFailure(coordinator)
        .multiModal {
            $0.alert(
                error: pushNotificationAuthCoordinator.status.failedValue,
                dismiss: pushNotificationAuthCoordinator.dismissFailure
            )
        }
        .animation(.rythmicoSpring(duration: .durationShort), value: coordinator.state.successValue)
    }

    var isFetchingStatus: Bool {
        currentStatus == .none && coordinator.state.isLoading
    }

    func tutorStatusFetched(_ newStatus: TutorStatus) {
        if newStatus != currentStatus {
            currentStatus = newStatus
            handleTutorStatus(newStatus)
        }
    }

    func handleTutorStatus(_ status: TutorStatus) {
        switch status {
        case .registrationPending(let formURL):
            webViewStore.load(formURL)
        case .interviewPending, .interviewFailed, .dbsPending, .dbsProcessing, .dbsFailed, .verified:
            pushNotificationAuthCoordinator.requestAuthorization()
        }
    }
}

#if DEBUG
struct TutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        TutorStatusView()
    }
}
#endif
