import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: String
    var titlePadding: EdgeInsets
    var content: Content

    init(title: String, titlePadding: EdgeInsets = .zero, @ViewBuilder content: () -> Content) {
        self.title = title
        self.titlePadding = titlePadding
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingSmall) {
            Text(title)
                .padding(titlePadding)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundColor(.rythmicoForeground)
                .rythmicoFont(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibility(addTraits: .isHeader)
            content
        }
    }
}
