import SwiftUISugar
import WebKit

struct RythmicoWebView: View {
    // Bit of a hack, needed cause WKWebViewDelegate/publisher is not reliable for URL changes.
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

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
        ZStack {
            WebView(webView: store.webView).transition(.opacity)
            if isLoading {
                ActivityIndicator(color: Color(.darkGray))
            }
        }
        .opacity(isDone ? 0 : 1)
        .animation(.easeInOut(duration: .durationShort), value: isDone)
        .onReceive(timer) { _ in attemptOnDone() }
    }

    private var isLoading: Bool {
        !isDone && store.isLoading
    }

    private var isDone: Bool {
        store.url?.absoluteString.hasSuffix("/blank") == true
    }

    private func attemptOnDone() {
        if isDone { onDone() }
    }
}

extension WebViewStore: Then {}

extension WKWebView {
    func load(_ url: URL) {
        load(URLRequest(url: url))
    }
}
