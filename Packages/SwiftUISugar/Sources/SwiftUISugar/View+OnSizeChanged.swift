extension View {
    public func onSizeChange(perform action: @escaping Handler<CGSize>) -> some View {
        self.background(SizeCategoryWatcher(action: action))
    }
}

private struct SizeCategoryWatcher: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let action: Handler<CGSize>

    var body: some View {
        GeometryReader { proxy in
            InteractiveBackground()
                .onAppear { action(proxy.size) }
                .onChange(of: sizeCategory) { _ in action(proxy.size) }
        }
    }
}
