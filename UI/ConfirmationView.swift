import SwiftUI

struct ConfirmationView: View {
    var title: String

    var body: some View {
        ZStack {
            Color(.systemBackground)
            HStack(spacing: .spacingExtraSmall) {
                Image(decorative: Asset.iconCheckmark.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmicoPurple)
                Text(title)
                    .rythmicoFont(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
            }
        }
    }
}
