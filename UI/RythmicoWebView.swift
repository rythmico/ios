import SwiftUISugar
import WebKit

struct RythmicoWebView: View {
    // Bit of a hack, needed cause WKWebViewDelegate/publisher is not reliable for URL changes.
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    @ObservedObject
    var store: WebViewStore
    let ignoreBottomSafeArea: Bool
    let onDone: Action

    init(store: WebViewStore, ignoreBottomSafeArea: Bool = false, onDone: @escaping Action) {
        self._store = .init(
            wrappedValue: store.then {
                $0.webView.scrollView.contentInsetAdjustmentBehavior = .never
                $0.webView.backgroundColor = .clear
                $0.webView.allowsBackForwardNavigationGestures = false
                $0.webView.allowsLinkPreview = false
            }
        )
        self.ignoreBottomSafeArea = ignoreBottomSafeArea
        self.onDone = onDone
    }

    var body: some View {
        ZStack {
            WebView(webView: store.webView).edgesIgnoringSafeArea(ignoreBottomSafeArea ? .bottom : [])
            if isLoading {
                ActivityIndicator(color: Color(.gray))
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

extension WebViewStore {
    func load(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
}
