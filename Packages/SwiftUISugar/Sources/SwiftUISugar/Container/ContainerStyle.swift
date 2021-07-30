import SwiftUI

public struct ContainerStyle: Hashable {
    public let fill: Color
    public let shape: Shape
    public let border: Border?

    public init(fill: Color, shape: Shape, border: Border?) {
        self.fill = fill
        self.shape = shape
        self.border = border
    }
}

extension ContainerStyle {
    public enum Shape: Hashable {
        case rectangle
        case roundedRectangle(radius: CGFloat, style: RoundedCornerStyle)
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
