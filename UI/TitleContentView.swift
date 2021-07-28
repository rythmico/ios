import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: String
    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat = .grid(3)
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            Text(title)
                .foregroundColor(.rythmico.foreground)
                .rythmicoTextStyle(.largeTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .frame(maxWidth: .grid(.max), alignment: .leading)
                .padding(.horizontal, .grid(5))
                .accessibility(addTraits: .isHeader)
            content
        }
        .padding(.top, .grid(1))
    }
}
