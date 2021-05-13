import SwiftUI

struct Pill<Content: View>: View {
    var backgroundColor: Color
    var borderColor: Color
    @ViewBuilder
    var content: Content

    var body: some View {
        content
            .padding(.vertical, 1)
            .padding(.horizontal, .spacingUnit * 3.5)
            .frame(minWidth: 96)
            .background(
                backgroundColor
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(borderColor, style: StrokeStyle(lineWidth: 2)))
            )
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
