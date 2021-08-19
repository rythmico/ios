public struct InteractiveBackground: View {
    private let color: Color

    public init(color: Color = .clear) {
        self.color = color
    }

    public var body: some View {
        if color == .clear {
            Color.black.opacity(0.0001)
        } else {
            color
        }
    }
}
