import SwiftUISugar

// MARK: Outline

extension ContainerStyle {
    enum OutlineRadius: CGFloat {
        case medium = 8
        case large = 12
    }

    static func outline(fill: Color = .clear, radius: OutlineRadius = .medium) -> Self {
        Self(
            fill: fill,
            shape: .squircle(radius: radius.rawValue, style: .continuous),
            border: .init(color: .rythmico.outline, width: 1.5)
        )
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
