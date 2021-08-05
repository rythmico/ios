import SwiftUISugar

// MARK: Outline

extension ContainerStyle {
    enum OutlineRadius: CGFloat {
        case medium = 8
        case large = 12
        static let `default` = medium
    }

    static let outlineBorderColor: Color = .rythmico.outline

    static func outline(fill: Fill = .color(.clear), radius: OutlineRadius = .default, borderColor: Color = outlineBorderColor) -> Self {
        Self(
            fill: fill,
            shape: .squircle(radius: radius.rawValue, style: .continuous),
            border: .init(color: borderColor, width: 1.5)
        )
    }

    static func outline(fill: Color, radius: OutlineRadius = .default, borderColor: Color = outlineBorderColor) -> Self {
        outline(fill: .color(fill), radius: radius, borderColor: borderColor)
    }

    static func outline(fill: LinearGradient, radius: OutlineRadius = .default, borderColor: Color = outlineBorderColor) -> Self {
        outline(fill: .linearGradient(fill), radius: radius, borderColor: borderColor)
    }
}

// MARK: - Box

extension ContainerStyle {
    static let box = Self(
        fill: .rythmico.gray2,
        shape: .squircle(radius: 8, style: .continuous),
        border: .none
    )
}

// MARK: - Field

extension ContainerStyle {
    static let field = Self(
        fill: .clear,
        shape: .squircle(radius: 4, style: .continuous),
        border: .init(color: .rythmico.outline, width: 1)
    )
}

#if DEBUG
struct Container_Previews: PreviewProvider {
    static let styles: [(String, ContainerStyle)] = [
        ("Outline (Medium Radius)", .outline(radius: .medium)),
        ("Outline (Large Radius)", .outline(radius: .large)),
        ("Box", .box),
        ("Field", .field),
    ]

    static var previews: some View {
        ForEach(styles, id: \.self.0) { style in
            Container(style: style.1) {
                Text("Hello World")
                    .padding()
                    .previewDisplayName(style.0)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
