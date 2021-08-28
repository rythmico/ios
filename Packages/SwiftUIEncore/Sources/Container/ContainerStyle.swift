public struct ContainerStyle {
    public let fill: Fill
    public let shape: Shape
    public let border: Border?

    public init(fill: Fill, shape: Shape, border: Border?) {
        self.fill = fill
        self.shape = shape
        self.border = border
    }
}

extension ContainerStyle {
    public init(fill: Color, shape: Shape, border: Border?) {
        self.init(fill: .color(fill), shape: shape, border: border)
    }

    public init(fill: LinearGradient, shape: Shape, border: Border?) {
        self.init(fill: .linearGradient(fill), shape: shape, border: border)
    }
}

extension ContainerStyle {
    // TODO: replace with AnyShapeStyle in iOS 15.
    public enum Fill {
        case color(Color)
        case linearGradient(LinearGradient)

        public var color: Color? {
            guard case .color(let color) = self else { return nil }
            return color
        }

        public var linearGradient: LinearGradient? {
            guard case .linearGradient(let linearGradient) = self else { return nil }
            return linearGradient
        }

        @ViewBuilder
        func fillShape<S: SwiftUI.Shape>(_ shape: S) -> some View {
            switch self {
            case .color(let color):
                shape.fill(color)
            case .linearGradient(let gradient):
                shape.fill(gradient)
            }
        }
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
