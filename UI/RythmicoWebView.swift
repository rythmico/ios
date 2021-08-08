import SwiftUISugar
import WebKit

struct RythmicoWebView: View {
    // Bit of a hack, needed cause WKWebViewDelegate/publisher is not reliable for URL changes.
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    let backgroundColor: UIColor
    @ObservedObject
    var store: WebViewStore
    let onDone: Action

    init(
        backgroundColor: UIColor,
        store: WebViewStore,
        onDone: @escaping Action
    ) {
        self.backgroundColor = backgroundColor
        self._store = .init(
            wrappedValue: store.then {
                $0.webView.scrollView.contentInsetAdjustmentBehavior = .never
                $0.webView.backgroundColor = backgroundColor
                $0.webView.allowsBackForwardNavigationGestures = false
                $0.webView.allowsLinkPreview = false
            }
        )
        self.onDone = onDone
    }

    var body: some View {
        WebView(webView: store.webView).onReceive(timer) { _ in attemptOnDone() }
    }

    private func attemptOnDone() {
        guard store.url?.absoluteString.hasSuffix("/blank") == true else { return }
        onDone()
    }
}

extension WebViewStore: Then {}

extension WKWebView {
    func load(_ url: URL) {
        load(URLRequest(url: url))
    }
}
