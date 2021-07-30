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
        .foregroundColor(.rythmico.foreground)
        .accentColor(.rythmico.foreground)
        .background(Color.rythmico.azureBlue)
        .clipShape(RoundedRectangle(cornerRadius: .grid(1), style: .continuous))
    }
}
