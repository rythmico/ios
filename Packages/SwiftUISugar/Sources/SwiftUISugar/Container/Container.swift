public struct Container<Content: View>: View {
    private var style: ContainerStyle
    private var content: Content

    public init(style: ContainerStyle, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }

    public var body: some View {
        switch style.shape {
        case .rectangle:
            body(for: Rectangle())
        case .roundedRectangle(let radius, let style):
            body(for: RoundedRectangle(cornerRadius: radius, style: style))
        case .capsule(let style):
            body(for: Capsule(style: style))
        case .circle:
            body(for: Circle())
        }
    }

    @ViewBuilder
    private func body<S: InsettableShape>(for shape: S) -> some View {
        content
            .clipShape(shape.inset(by: clipShapeInset))
            .background(shape.fill(style.fill))
            .overlay(outlineOverlay(for: shape))
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
