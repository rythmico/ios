import SwiftUI

struct TitleSubtitleView: View {
    var title: String
    var subtitle: [MultiWeightText.Part]

    init(title: String, subtitle: [MultiWeightText.Part]) {
        self.title = title
        self.subtitle = subtitle
    }

    init(title: String, subtitle: String) {
        self.init(title: title, subtitle: [.regular(subtitle)])
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title).rythmicoFont(.largeTitle)
            MultiWeightText(style: .body, parts: subtitle).foregroundColor(.rythmicoGray90)
        }
        .padding(.horizontal, 20)
    }
}
