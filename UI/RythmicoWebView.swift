import SwiftUISugar
import WebKit

struct RythmicoWebView: View {
    private let delegate = RythmicoWebViewDelegate()

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
        WebView(webView: store.webView).onAppear(perform: setUpDelegate)
    }

    func setUpDelegate() {
        delegate.onBlankPage = onDone
        store.webView.navigationDelegate = delegate
    }
}

private final class RythmicoWebViewDelegate: NSObject, WKNavigationDelegate {
    var onBlankPage: Action?

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard webView.url?.absoluteString.hasSuffix("/blank") == true else { return }
        onBlankPage?()
    }
}

extension WebViewStore: Then {}

extension WKWebView {
    func load(_ url: URL) {
        load(URLRequest(url: url))
    }
}
