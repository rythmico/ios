import SwiftUI

struct TitleSubtitleView: View {
    var title: String
    var subtitle: Text?

    init(title: String, subtitle: Text? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        TitleContentView(title: title) {
            subtitle?
                .foregroundColor(.rythmicoGray90)
                .rythmicoTextStyle(.body)
                .frame(maxWidth: .spacingMax, alignment: .leading)
                .padding(.horizontal, .spacingMedium)
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
