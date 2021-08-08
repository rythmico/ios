import SwiftUISugar

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
                    RythmicoWebView(
                        backgroundColor: .white,
                        store: webViewStore,
                        onDone: coordinator.run
                    )
                    .edgesIgnoringSafeArea(.bottom)
                case .interviewPending, .interviewFailed, .dbsPending, .dbsProcessing, .dbsFailed, .verified:
                    TutorStatusBanner(status: status)
                }
            }
            if isLoading {
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

    var isLoading: Bool {
        switch currentStatus {
        case .none:
            return coordinator.state.isLoading
        case .registrationPending:
            return webViewStore.isLoading
        case .interviewPending, .interviewFailed, .dbsPending, .dbsProcessing, .dbsFailed, .verified:
            return false
        }
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
            webViewStore.webView.load(formURL)
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
