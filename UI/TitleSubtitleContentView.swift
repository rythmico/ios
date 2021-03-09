import SwiftUI

struct TitleSubtitleContentView<Content: View>: View {
    var title: String
    var subtitle: [MultiStyleText.Part]
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: .spacingExtraLarge) {
            TitleSubtitleView(title: title, subtitle: subtitle).padding(.horizontal, .spacingMedium)
            content
        }
    }
}

extension TitleSubtitleContentView {
    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.init(title: title, subtitle: [.init(subtitle)], content: content)
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
