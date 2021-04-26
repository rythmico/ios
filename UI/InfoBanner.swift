import SwiftUI

struct InfoBanner: View {
    var text: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .spacingExtraSmall) {
            Image(decorative: Asset.iconInfo.name)
                .renderingMode(.template)
                .alignmentGuide(.firstTextBaseline) { $0[.bottom] - .spacingUnit }
            Text(text)
                .rythmicoTextStyle(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.spacingSmall)
        .foregroundColor(.rythmicoForeground)
        .accentColor(.rythmicoForeground)
        .background(Color.rythmicoExtraLightBlue)
        .clipShape(RoundedRectangle(cornerRadius: .spacingUnit, style: .continuous))
    }
}
