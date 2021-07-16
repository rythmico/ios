import SwiftUI

struct InfoBanner: View {
    var text: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .grid(3)) {
            Image(decorative: Asset.Icon.Label.info.name)
                .renderingMode(.template)
                .alignmentGuide(.firstTextBaseline) { $0[.bottom] - .grid(1) }
            Text(text)
                .rythmicoTextStyle(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.grid(4))
        .foregroundColor(.rythmicoForeground)
        .accentColor(.rythmicoForeground)
        .background(Color.rythmicoExtraLightBlue)
        .clipShape(RoundedRectangle(cornerRadius: .grid(1), style: .continuous))
    }
}
