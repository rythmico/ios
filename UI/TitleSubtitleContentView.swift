import SwiftUI

struct TitleSubtitleContentView<Content: View>: View {
    var title: String
    var subtitle: Text? = nil
    var spacing: CGFloat = .spacingExtraLarge
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: spacing) {
            TitleSubtitleView(title: title, subtitle: subtitle)
            content
        }
    }
}

extension TitleSubtitleContentView {
    init(
        title: String,
        subtitle: String,
        spacing: CGFloat = .spacingExtraLarge,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title: title, subtitle: Text(subtitle), spacing: spacing, content: content)
    }
}

#if DEBUG
struct TitleSubtitleContentView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleContentView(title: "Title", subtitle: "Subtitle") {
            Color.red
        }
    }
}
#endif
