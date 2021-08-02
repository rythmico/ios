import SwiftUI

struct InlineContentAndTitleView<Content: View>: View {
    @ViewBuilder
    var content: Content
    var title: String
    var bold: Bool

    var body: some View {
        HStack(spacing: .grid(3)) {
            content
                .fixedSize()
            Text(title)
                .rythmicoTextStyle(bold ? .bodySemibold : .body)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
