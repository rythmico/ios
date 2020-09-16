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
            .padding(.horizontal, .spacingUnit * 3.5)
            .frame(minWidth: 96)
            .background(color.clipShape(Capsule()))
    }
}

extension Pill where Content == AnyView {
    init(
        title: String,
        titleColor: Color,
        backgroundColor: Color
    ) {
        self.init(color: backgroundColor) {
            AnyView(
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .rythmicoFont(.bodyMedium)
                    .foregroundColor(titleColor)
            )
        }
    }
}
