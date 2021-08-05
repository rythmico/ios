import SwiftUISugar

struct Pill<Content: View>: View {
    var backgroundColor: Color
    var borderColor: Color
    @ViewBuilder
    var content: Content

    var body: some View {
        Container(
            style: .init(
                fill: backgroundColor,
                shape: .capsule(style: .continuous),
                border: .init(color: borderColor, width: 2)
            )
        ) {
            content
                .padding(.vertical, 1)
                .padding(.horizontal, .grid(3.5))
                .frame(minWidth: 96)
        }
    }
}

extension Pill where Content == AnyView {
    init(
        title: String,
        titleColor: Color,
        backgroundColor: Color,
        borderColor: Color
    ) {
        self.init(backgroundColor: backgroundColor, borderColor: borderColor) {
            AnyView(
                Text(title)
                    .foregroundColor(titleColor)
                    .rythmicoTextStyle(.bodyMedium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            )
        }
    }
}
