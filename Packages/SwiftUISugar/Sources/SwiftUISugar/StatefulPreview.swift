public struct StatefulPreview<A, B, C, Content: View>: View {
    @State
    private var a: A
    @State
    private var b: B
    @State
    private var c: C
    @ViewBuilder
    private let content: ABCToContent

    public var body: some View {
        content($a, $b, $c)
    }
}

extension StatefulPreview {
    public typealias AToContent = (Binding<A>) -> Content
    public typealias ABToContent = (Binding<A>, Binding<B>) -> Content
    public typealias ABCToContent = (Binding<A>, Binding<B>, Binding<C>) -> Content
}

extension StatefulPreview where B == Void, C == Void {
    public init(
        _ a: A,
        @ViewBuilder content: @escaping AToContent
    ) {
        self._a = .init(initialValue: a)
        self._b = .init(initialValue: ())
        self._c = .init(initialValue: ())
        self.content = { a, _, _ in content(a) }
    }
}

extension StatefulPreview where C == Void {
    public init(
        _ a: A,
        _ b: B,
        @ViewBuilder content: @escaping ABToContent
    ) {
        self._a = .init(initialValue: a)
        self._b = .init(initialValue: b)
        self._c = .init(initialValue: ())
        self.content = { a, b, _ in content(a, b) }
    }
}

extension StatefulPreview {
    public init(
        _ a: A,
        _ b: B,
        _ c: C,
        @ViewBuilder content: @escaping ABCToContent
    ) {
        self._a = .init(initialValue: a)
        self._b = .init(initialValue: b)
        self._c = .init(initialValue: c)
        self.content = { a, b, c in content(a, b, c) }
    }
}
