import SwiftUI

struct TitleSubtitleContentView<Content: View>: View {
    var title: String
    var subtitle: [MultiStyleText.Part]
    var content: Content

    init(title: String, subtitle: [MultiStyleText.Part], @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.init(title: title, subtitle: [.init(subtitle)], content: content)
    }

    var body: some View {
        VStack(spacing: .spacingExtraLarge) {
            TitleSubtitleView(title: title, subtitle: subtitle)
            content
        }.padding(.horizontal, .spacingMedium)
    }
}
