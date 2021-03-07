import SwiftUI

/// Time-aware view.
struct TickingView<Content: View>: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let contentBuilder: () -> Content

    @State
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.contentBuilder = content
        self._content = State(initialValue: content())
    }

    var body: some View {
        ZStack {
            content
        }
        .animation(.none)
        .onReceive(timer) { _ in
            content = contentBuilder()
        }
    }
}

struct TickingText: View {
    var body: TickingView<Text>

    init<S: StringProtocol>(_ string: @autoclosure @escaping () -> S) {
        body = TickingView { Text(string()) }
    }
}
