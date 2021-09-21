public struct TransientStateView<Value, Content: View>: View {
    let delay: Double?
    let from: Value
    let to: Value
    let content: (Value) -> Content

    public init(
        delay: Double? = nil,
        from: Value,
        to: Value,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.delay = delay
        self.from = from
        self.to = to
        self.content = content
    }

    public var body: some View {
        StatefulView(from) { $value in
            content(value).onAppear {
                if let delay = delay {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        value = to
                    }
                } else {
                    value = to
                }
            }
        }
    }
}
