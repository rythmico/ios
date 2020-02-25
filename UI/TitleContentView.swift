import SwiftUI

struct TitleContentView<Content: View>: View {
    var title: [MultiStyleText.Part]
    var content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = [.init(title)]
        self.content = content
    }

    init(title: [MultiStyleText.Part], @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
            MultiStyleText(style: .callout, parts: title)
            content()
        }
    }
}
