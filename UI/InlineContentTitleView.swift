import SwiftUISugar

struct InlineContentTitleView<Content: View>: View {
    @ViewBuilder
    let content: Content
    let title: String

    var body: some View {
        InlineContentTitleSubtitleView(content: { content }, title: title, subtitle: nil)
    }
}
