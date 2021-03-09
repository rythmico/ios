import SwiftUI

struct TitleSubtitleView: View {
    var title: String
    var subtitle: [MultiStyleText.Part]

    init(title: String, subtitle: [MultiStyleText.Part]) {
        self.title = title
        self.subtitle = subtitle
    }

    init(title: String, subtitle: String) {
        self.init(title: title, subtitle: [subtitle.part])
    }

    var body: some View {
        TitleContentView(title: title) {
            MultiStyleText(
                parts: subtitle.map { $0.color($0.color ?? .rythmicoGray90) }
            )
            .transition(.offset(y: -50) + .opacity)
        }
    }
}

#if DEBUG
struct TitleSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleView(title: "Title", subtitle: "Subtitle").background(Color.blue)
        TitleSubtitleView(title: "Title", subtitle: []).background(Color.blue)
    }
}
#endif
