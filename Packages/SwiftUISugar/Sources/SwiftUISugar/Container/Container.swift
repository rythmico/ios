public struct Container<Content: View>: View {
    private var style: ContainerStyle
    private var content: () -> Content

    public init(style: ContainerStyle, @ViewBuilder content: @escaping () -> Content) {
        self.style = style
        self.content = content
    }

    public var body: some View {
        switch style.shape {
        case .rectangle:
            body(for: Rectangle())
        case .squircle(let radius, let style):
            body(for: RoundedRectangle(cornerRadius: radius, style: style))
        case .capsule(let style):
            body(for: Capsule(style: style))
        case .circle:
            body(for: Circle())
        }
    }

    @ViewBuilder
    private func body<S: InsettableShape>(for shape: S) -> some View {
        ZStack(content: content)
            .clipShape(shape.inset(by: clipShapeInset))
            .background(style.fill.fillShape(shape))
            .overlay(outlineOverlay(for: shape))
            .contentShape(Rectangle())
    }

    private var clipShapeInset: CGFloat {
        (style.border?.width ?? 0) / 2
    }

    @ViewBuilder
    private func outlineOverlay<S: InsettableShape>(for shape: S) -> some View {
        if let border = style.border {
            shape.strokeBorder(border.color, lineWidth: border.width)
        }
    }
}
