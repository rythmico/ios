import SwiftUI

struct Pill<Content: View>: View {
    var color: Color
    var content: Content

    init(color: Color, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }

    var body: some View {
        content
            .padding(.vertical, .spacingUnit / 2)
            .padding(.horizontal, .spacingExtraSmall)
            .frame(minWidth: 96)
            .background(color.clipShape(Capsule()))
    }
}

struct TextPill: View {
    var title: String
    var titleColor: Color
    var backgroundColor: Color

    var body: some View {
        Pill(color: backgroundColor) {
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .rythmicoFont(.bodyMedium)
                .foregroundColor(titleColor)
        }
    }
}
