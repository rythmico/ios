import SwiftUI

struct TitleSubtitleView: View {
    var title: String
    var subtitle: [MultiStyleText.Part]

    init(title: String, subtitle: [MultiStyleText.Part]) {
        self.title = title
        self.subtitle = subtitle
    }

    init(title: String, subtitle: String) {
        self.init(title: title, subtitle: [.init(subtitle)])
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: .spacingSmall) {
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .foregroundColor(.rythmicoForeground)
                    .rythmicoFont(.largeTitle)
                    .accessibility(addTraits: .isHeader)
                MultiStyleText(parts: subtitle.map { $0.color(.rythmicoGray90) })
                    .transition(
                        AnyTransition
                            .opacity
                            .combined(with: .offset(y: -50))
                    )
            }
            Spacer()
        }
    }
}

#if DEBUG
struct TitleSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TitleSubtitleView(title: "Title", subtitle: "Subtitle").background(Color.blue)
            TitleSubtitleView(title: "Title", subtitle: []).background(Color.blue)
        }
    }
}
#endif
