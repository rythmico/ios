import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: String
    var titlePadding: EdgeInsets = .zero
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingSmall) {
            Text(title)
                .padding(titlePadding)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .foregroundColor(.rythmicoForeground)
                .rythmicoFont(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibility(addTraits: .isHeader)
            content
        }
    }
}
