import SwiftUI

struct TitleSubtitleView: View {
    var title: String
    var subtitle: Text?

    init(title: String, subtitle: Text? = nil) {
        self.title = title
        self.subtitle = subtitle?.foregroundColor(.rythmicoGray90).rythmicoFont(.body)
    }

    var body: some View {
        TitleContentView(title: title) {
            subtitle
                .lineSpacing(6)
                .transition(.offset(y: -50) + .opacity)
        }
    }
}

extension TitleSubtitleView {
    init(title: String, subtitle: String) {
        self.init(title: title, subtitle: Text(subtitle))
    }
}

#if DEBUG
struct TitleSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleView(title: "Title", subtitle: "Subtitle").background(Color.blue)
        TitleSubtitleView(title: "Title", subtitle: nil).background(Color.blue)
    }
}
#endif
