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
                MultiStyleText(
                    style: .body,
                    parts: subtitle.map { .init($0.string, weight: $0.weight, color: .rythmicoGray90) }
                )
                .transition(
                    AnyTransition
                        .opacity
                        .combined(with: .offset(y: -50)
                    )
                )
            }
            Spacer()
        }
    }
}
