import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: [MultiStyleText.Part]
    var style: Font.TextStyle
    var content: Content

    init(
        title: [MultiStyleText.Part],
        style: Font.TextStyle = .callout,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.style = style
        self.content = content()
    }

    init(title: String, @ViewBuilder content: () -> Content) {
        self.init(title: [.init(title)], content: content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
            MultiStyleText(style: style, parts: title)
            content
        }
    }
}
