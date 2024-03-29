import SwiftUIEncore

struct InlineContentTitleView<Content: View>: View {
    @ViewBuilder
    let content: Content
    let title: String

    var body: some View {
        InlineContentTitleSubtitleView(content: { content }, title: title, titleStyle: .body, subtitle: nil)
    }
}
