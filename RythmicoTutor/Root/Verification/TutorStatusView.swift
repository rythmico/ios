import SwiftUISugar
import WebKit

extension WebViewStore: Then {}

struct TutorStatusView: View {
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator
    @ObservedObject
    private var coordinator = Current.tutorStatusFetchingCoordinator
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
                case .registrationPending:
                    WebView(webView: webViewStore.webView).edgesIgnoringSafeArea(.bottom)
                case .interviewPending, .interviewFailed, .dbsPending, .dbsProcessing, .dbsFailed, .verified:
                    TutorStatusBanner(status: status)
                }
            }
            if isLoading {
                ActivityIndicator(color: .gray)
            }
        }
        .onAppear(perform: Current.deviceRegisterCoordinator.registerDevice)
        .onAppear(perform: setUpWebViewDelegate)
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
        case .registrationPending(let formURL):
            webViewStore.webView.load(URLRequest(url: formURL))
        case .interviewPending, .interviewFailed, .dbsPending, .dbsProcessing, .dbsFailed, .verified:
            pushNotificationAuthCoordinator.requestAuthorization()
        }
    }
}

private final class TutorSignUpWebViewDelegate: NSObject, WKNavigationDelegate {
    var onAboutBlank: Action?

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard webView.url?.absoluteString == "https://rythmico-prod.web.app/blank" else { return }
        onAboutBlank?()
    }
}

#if DEBUG
struct TutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        TutorStatusView()
    }
}
#endif
