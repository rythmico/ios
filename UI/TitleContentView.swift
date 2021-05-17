import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: String
    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat = .spacingExtraSmall
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            Text(title)
                .foregroundColor(.rythmicoForeground)
                .rythmicoTextStyle(.largeTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .frame(maxWidth: .spacingMax, alignment: .leading)
                .padding(.horizontal, .spacingMedium)
                .accessibility(addTraits: .isHeader)
            content
        }
        .padding(.top, .spacingUnit)
    }
}
