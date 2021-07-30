public struct Container<Content: View>: View {
    private var style: ContainerStyle
    private var content: Content

    public init(style: ContainerStyle, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }

    public var body: some View {
        if let corner = style.corner {
            switch corner.radius {
            case .value(let radius):
                body(for: RoundedRectangle(cornerRadius: radius, style: corner.rounding))
            case .capsule:
                body(for: Capsule(style: corner.rounding))
            }
        } else {
            body(for: Rectangle())
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
