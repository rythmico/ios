import SwiftUI
import WebView
import WebKit
import Sugar
import Then

extension WebViewStore: Then {}

struct TutorStatusView: View {
    private let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()!
    @ObservedObject
    private var coordinator = Current.sharedCoordinator(for: \.tutorStatusFetchingService)!
    @State
    private var currentStatus: TutorStatus?
    @StateObject
    private var webViewStore = WebViewStore().then {
        $0.webView.scrollView.contentInsetAdjustmentBehavior = .never
        $0.webView.backgroundColor = .white
        $0.webView.allowsBackForwardNavigationGestures = false
        $0.webView.allowsLinkPreview = false
    }
    private let webViewDelegate = TutorSignUpWebViewDelegate()

    var body: some View {
        ZStack {
            if let status = currentStatus {
                switch status {
                case .notRegistered:
                    WebView(webView: webViewStore.webView).edgesIgnoringSafeArea(.bottom)
                case .notCurated, .notDBSChecked:
                    TutorStatusBanner(description: status.bannerText)
                case .verified:
                    EmptyView()
                }
            }
            if isLoading {
                ActivityIndicator(color: .gray)
            }
        }
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
        .onAppear(perform: setUpWebViewDelegate)
        .onAppear(perform: coordinator.run)
        .onEvent(.appInForeground, perform: coordinator.run)
        .onSuccess(coordinator, perform: tutorStatusFetched)
        .alertOnFailure(coordinator)
        .animation(.rythmicoSpring(duration: .durationShort), value: coordinator.state.successValue)
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

    func setUpWebViewDelegate() {
        webViewDelegate.onAboutBlank = coordinator.run
        webViewStore.webView.navigationDelegate = webViewDelegate
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
}

private final class TutorSignUpWebViewDelegate: NSObject, WKNavigationDelegate {
    var onAboutBlank: Action?

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard webView.url?.absoluteString == "about:blank" else { return }
        onAboutBlank?()
    }
}

private extension TutorStatus {
    var bannerText: String {
        switch self {
        case .notCurated:
            return  """
                    Thank you for signing up as a Rythmico Tutor.

                    We will review your submission and reach out to you within a few days.
                    """
        case .notDBSChecked:
            return  """
                    Your mandatory DBS check form is now ready.

                    Please follow the link sent to your inbox provided by uCheck.
                    """
        case .notRegistered, .verified:
            return .empty
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
