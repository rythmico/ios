import SwiftUISugar

struct InlineContentTitleSubtitleView<Content: View>: View {
    @ViewBuilder
    let content: Content
    let title: String
    var titleStyle: Font.RythmicoTextStyle = .bodyMedium
    let subtitle: String?

    var body: some View {
        HStack(spacing: .grid(3)) {
            content
            VStack(alignment: .leading, spacing: .grid(1)) {
                Text(title)
                    .rythmicoTextStyle(titleStyle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .rythmicoTextStyle(.footnote)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
