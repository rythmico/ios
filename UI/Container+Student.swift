import SwiftUISugar

// MARK: Outline

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

// MARK: - Box

extension ContainerStyle {
    static let box = Self(
        background: .rythmico.gray2,
        corner: .init(rounding: .continuous, radius: 8),
        border: .none
    )
}

#if DEBUG
struct Container_Previews: PreviewProvider {
    static let styles: [(String, ContainerStyle)] = [
        ("Outline (Medium Radius)", .outline(radius: .medium)),
        ("Outline (Large Radius)", .outline(radius: .large)),
        ("Box", .box),
    ]

    static var previews: some View {
        ForEach(styles, id: \.self.1) { style in
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
