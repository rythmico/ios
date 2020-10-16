import SwiftUI

struct InfoBanner: View {
    var text: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .spacingExtraSmall) {
            VectorImage(asset: Asset.iconInfo)
                .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 3 }
            Text(text)
                .rythmicoFont(.callout)
                .lineSpacing(.spacingUnit)
        }
        .padding(.spacingSmall)
        .foregroundColor(.rythmicoForeground)
        .accentColor(.rythmicoForeground)
        .background(Color.rythmicoLightBlue)
        .clipShape(RoundedRectangle(cornerRadius: .spacingUnit, style: .continuous))
    }
}
