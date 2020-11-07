import SwiftUI

struct InlineContentAndTitleView<Content: View>: View {
    var content: Content
    var title: String
    var bold: Bool

    init(@ViewBuilder content: () -> Content, title: String, bold: Bool) {
        self.content = content()
        self.title = title
        self.bold = bold
    }

    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            content
                .fixedSize()
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .rythmicoFont(bold ? .bodySemibold : .body)
                .foregroundColor(.rythmicoGray90)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
