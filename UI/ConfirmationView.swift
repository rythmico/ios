import SwiftUI

struct ConfirmationView: View {
    var title: String

    var body: some View {
        ZStack {
            Color.clear
            HStack(spacing: .spacingExtraSmall) {
                Image(decorative: Asset.Icon.Misc.checkmark.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmicoPurple)
                Text(title)
                    .rythmicoTextStyle(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
            }
        }
    }
}

#if DEBUG
struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(title: "Plan cancelled successfully")
            .previewLayout(.sizeThatFits)
    }
}
#endif
