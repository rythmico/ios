import SwiftUI
import WebView
import Then

extension WebViewStore: Then {}

struct TutorStatusView: View {
    @ObservedObject
    private var coordinator = Current.sharedCoordinator(for: \.tutorStatusFetchingService)!
    @State
    private var currentStatus: TutorStatus?
    @StateObject
    private var webViewStore = WebViewStore().then {
        $0.webView.scrollView.contentInsetAdjustmentBehavior = .never
        $0.webView.backgroundColor = .white
    }

    var body: some View {
        ZStack {
            if let status = currentStatus {
                switch status {
                case .notRegistered:
                    WebView(webView: webViewStore.webView).edgesIgnoringSafeArea(.bottom)
                case .notCurated:
                    TutorStatusBanner(
                        """
                        Thank you for signing up as a Rythmico Tutor.

                        We will review your submission and reach out to you within a few days.
                        """
                    )
                case .notDBSChecked:
                    TutorStatusBanner(
                        """
                        Your mandatory DBS check form is now ready.

                        Please follow the link sent to your inbox provided by uCheck.
                        """
                    )
                case .verified:
                    EmptyView()
                }
            }
            if isLoading {
                ActivityIndicator(color: .gray)
            }
        }
        .onAppear(perform: coordinator.startToIdle)
        .onEvent(.appInForeground, perform: coordinator.startToIdle)
        .onSuccess(coordinator, perform: tutorStatusFetched)
        .alertOnFailure(coordinator)
    }

    func tutorStatusFetched(_ newStatus: TutorStatus) {
        if newStatus != currentStatus {
            currentStatus = newStatus
            handleTutorStatus(newStatus)
        }
    }

    func handleTutorStatus(_ status: TutorStatus) {
        switch status {
        case .notRegistered(let formURL):
            webViewStore.webView.load(URLRequest(url: formURL))
        case .notCurated, .notDBSChecked:
            break
        case .verified:
            Current.settings.tutorVerified = true
        }
    }

    var isLoading: Bool {
        switch currentStatus {
        case .none:
            return coordinator.state.isLoading
        case .notRegistered:
            return webViewStore.isLoading
        case .notCurated, .notDBSChecked, .verified:
            return false
        }
    }
}

#if DEBUG
struct TutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Current.tutorStatusFetchingService = APIServiceStub(result: .success(.notCurated))
        Current.tutorStatusFetchingService = APIServiceStub(result: .success(.notDBSChecked))
        return TutorStatusView()
    }
}
#endif
