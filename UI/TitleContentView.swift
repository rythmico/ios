import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: [MultiStyleText.Part]
    var content: Content

    init(title: [MultiStyleText.Part], @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    init(title: String, @ViewBuilder content: () -> Content) {
        self.init(title: [title.style(.bodyBold)], content: content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
            MultiStyleText(parts: title)
            content
        }
    }
}
