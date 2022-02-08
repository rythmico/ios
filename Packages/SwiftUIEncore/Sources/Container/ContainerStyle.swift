public struct ContainerStyle {
    // TODO: consider `any SwiftUI.ShapeStyle` when existentials are introduced.
    public typealias Fill = AnyShapeStyle

    public let fill: Fill
    // TODO: consider `any SwiftUI.Shape` when existentials are introduced.
    public let shape: Shape
    public let border: Border?

    public init(fill: Fill, shape: Shape, border: Border?) {
        self.fill = fill
        self.shape = shape
        self.border = border
    }
}

extension ContainerStyle {
    // TODO: use `fill: some ShapeStyle` when Opaque Parameter Declarations are introduced.
    // https://github.com/apple/swift-evolution/blob/main/proposals/0341-opaque-parameters.md
    public init<SomeFill: ShapeStyle>(fill: SomeFill, shape: Shape, border: Border?) {
        self.init(fill: AnyShapeStyle(fill), shape: shape, border: border)
    }
}

extension ContainerStyle {
    public enum Shape: Hashable {
        case rectangle
        case squircle(radius: CGFloat, style: RoundedCornerStyle)
        case capsule(style: RoundedCornerStyle)
        case circle
    }
}

extension ContainerStyle {
    public struct Border: Hashable {
        public let color: Color
        public let width: CGFloat

        public init(color: Color, width: CGFloat) {
            self.color = color
            self.width = width
        }
    }
}

extension ContainerStyle {
    public static let plain = Self(fill: .clear, shape: .rectangle, border: .none)
}
