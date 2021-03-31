import SwiftUI

struct Pill<Content: View>: View {
    var color: Color
    @ViewBuilder
    var content: Content

    var body: some View {
        content
            .padding(.bottom, .spacingUnit / 2)
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
