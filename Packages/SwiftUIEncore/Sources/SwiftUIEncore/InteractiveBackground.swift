public struct InteractiveBackground: View {
    private let color: Color

    public init(color: Color = .clear) {
        self.color = color == .clear ? Color.black.opacity(0.0001) : color
    }

    public var body: some View { color }
}
