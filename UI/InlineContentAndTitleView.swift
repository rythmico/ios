import SwiftUI

struct InlineContentAndTitleView<Content: View>: View {
    @ViewBuilder
    var content: Content
    var title: String
    var bold: Bool

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
