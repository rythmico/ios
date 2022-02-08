import SwiftUIEncore

// MARK: Outline

extension ContainerStyle {
    enum OutlineRadius: CGFloat {
        case medium = 8
        case large = 12
        static let `default` = medium
    }

    static let outlineBorderColor: Color = .rythmico.outline

    // TODO: use `fill: some ShapeStyle` when Opaque Parameter Declarations are introduced.
    // https://github.com/apple/swift-evolution/blob/main/proposals/0341-opaque-parameters.md
    static func outline<SomeFill: ShapeStyle>(fill: SomeFill, radius: OutlineRadius = .default, borderColor: Color = outlineBorderColor) -> Self {
        Self(
            fill: fill,
            shape: .squircle(radius: radius.rawValue, style: .continuous),
            border: .init(color: borderColor, width: 1.5)
        )
    }

    static func outline(radius: OutlineRadius = .default, borderColor: Color = outlineBorderColor) -> Self {
        outline(fill: .clear, radius: radius, borderColor: borderColor)
    }
}

// MARK: - Box

extension ContainerStyle {
    enum BoxRadius: CGFloat {
        case small = 4
        case medium = 8
        static let `default` = medium
    }

    static func box(radius: BoxRadius = .default) -> Self {
        Self(
            fill: Color.rythmico.gray2,
            shape: .squircle(radius: radius.rawValue, style: .continuous),
            border: .none
        )
    }
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
        ("Box (Small Radius)", .box(radius: .small)),
        ("Box (Medium Radius)", .box(radius: .medium)),
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
