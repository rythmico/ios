import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: String
    var content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: .spacingSmall) {
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .foregroundColor(.rythmicoForeground)
                    .rythmicoFont(.largeTitle)
                    .accessibility(addTraits: .isHeader)
                content
            }
            Spacer()
        }
    }
}
