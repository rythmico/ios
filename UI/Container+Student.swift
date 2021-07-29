import SwiftUISugar

extension ContainerStyle.CornerStyle {
    enum OutlineRadius: CGFloat {
        case medium = 8
        case large = 12
    }
}

extension ContainerStyle {
    static func outline(radius: CornerStyle.OutlineRadius = .medium) -> Self {
        Self(
            background: .clear,
            corner: .init(rounding: .continuous, radius: .value(radius.rawValue)),
            border: .init(color: .rythmico.outline, width: 1.5)
        )
    }
}
