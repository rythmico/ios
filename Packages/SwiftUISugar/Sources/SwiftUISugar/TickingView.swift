// TODO: replace with SwiftUI.TimelineView in iOS 15

/// Time-aware view.
public struct TickingView<Content: View>: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let contentBuilder: () -> Content

    @State
    private var content: Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.contentBuilder = content
        self._content = State(initialValue: content())
    }

    public var body: some View {
        ZStack {
            content
        }
        .animation(.none)
        .onReceive(timer) { _ in
            content = contentBuilder()
        }
    }
}

// TODO: allow TextStyle or remove altogether
public struct TickingText: View {
    public var body: TickingView<Text>

    public init<S: StringProtocol>(_ string: @autoclosure @escaping () -> S) {
        body = TickingView { Text(string()) }
    }
}
