public struct TransientStateView<Value, Content: View>: View {
    let from: Value
    let to: Value
    let delay: Double?
    let content: (Value) -> Content

    public init(
        from: Value,
        to: Value,
        delay: Double? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.from = from
        self.to = to
        self.delay = delay
        self.content = content
    }

    public var body: some View {
        StatefulView(from) { value in
            content(value.wrappedValue).onAppear {
                if let delay = delay {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        value.wrappedValue = to
                    }
                } else {
                    value.wrappedValue = to
                }
            }
        }
    }
}
