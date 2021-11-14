import TutorDO
import SwiftUIEncore

struct TutorProfileStatusView: View {
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator
    @ObservedObject
    private var coordinator = Current.tutorProfileStatusFetchingCoordinator
    @State
    private var currentStatus: TutorDTO.ProfileStatus?
    @StateObject
    private var webViewStore = WebViewStore()

    var body: some View {
        ZStack {
            if let status = currentStatus {
                switch status {
                case .registrationPending:
                    RythmicoWebView(store: webViewStore, ignoreBottomSafeArea: true, onDone: coordinator.run)
                case .interviewPending, .interviewFailed, .verified:
                    TutorProfileStatusBanner(status: status)
                }
            }
            if isFetchingStatus {
                ActivityIndicator(color: .gray)
            }
        }
        .onAppear(perform: coordinator.run)
        .onEvent(.appInForeground, perform: coordinator.run)
        .onSuccess(coordinator, perform: tutorProfileStatusFetched)
        .alertOnFailure(coordinator)
        .multiModal {
            $0.alert(
                error: pushNotificationAuthCoordinator.status.failedValue,
                dismiss: pushNotificationAuthCoordinator.dismissFailure
            )
        }
        .animation(.rythmicoSpring(duration: .durationShort), value: coordinator.output?.value)
    }

    var isFetchingStatus: Bool {
        currentStatus == .none && coordinator.state.isLoading
    }

    func tutorProfileStatusFetched(_ newStatus: TutorDTO.ProfileStatus) {
        if newStatus != currentStatus {
            currentStatus = newStatus
            handleTutorProfileStatus(newStatus)
        }
    }

    func handleTutorProfileStatus(_ status: TutorDTO.ProfileStatus) {
        switch status {
        case .registrationPending(let formURL):
            webViewStore.load(formURL)
        case .interviewPending, .interviewFailed, .verified:
            pushNotificationAuthCoordinator.requestAuthorization()
        }
    }
}

#if DEBUG
struct TutorProfileStatusView_Previews: PreviewProvider {
    static var previews: some View {
        TutorProfileStatusView()
    }
}
#endif
