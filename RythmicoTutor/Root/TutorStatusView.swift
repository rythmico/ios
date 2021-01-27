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
            Color.white.edgesIgnoringSafeArea(.bottom)
            if let status = currentStatus {
                switch status {
                case .notRegistered:
                    WebView(webView: webViewStore.webView).edgesIgnoringSafeArea(.bottom)
                case .notCurated:
                    EmptyView()
                case .notDBSChecked:
                    EmptyView()
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
