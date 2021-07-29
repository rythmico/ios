public struct ContainerStyle: Hashable {
    public let background: Color
    public let corner: CornerStyle?
    public let border: BorderStyle?

    public init(background: Color, corner: ContainerStyle.CornerStyle?, border: ContainerStyle.BorderStyle?) {
        self.background = background
        self.corner = corner
        self.border = border
    }
}

extension ContainerStyle {
    public struct CornerStyle: Hashable {
        public let rounding: RoundedCornerStyle
        public let radius: Radius

        public init(rounding: RoundedCornerStyle, radius: ContainerStyle.CornerStyle.Radius) {
            self.rounding = rounding
            self.radius = radius
        }
    }
}

extension ContainerStyle.CornerStyle {
    public enum Radius: Hashable {
        case value(CGFloat)
        case capsule
    }
}

extension ContainerStyle.CornerStyle.Radius: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public init(floatLiteral value: FloatLiteralType) { self = .value(CGFloat(value)) }
    public init(integerLiteral value: IntegerLiteralType) { self = .value(CGFloat(value)) }
}

extension ContainerStyle {
    public struct BorderStyle: Hashable {
        public let color: Color
        public let width: CGFloat

        public init(color: Color, width: CGFloat) {
            self.color = color
            self.width = width
        }
    }
}
