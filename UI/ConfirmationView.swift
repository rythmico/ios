import SwiftUI

struct ConfirmationView: View {
    var title: String

    var body: some View {
        ZStack {
            Color(.systemBackground)
            HStack(spacing: .spacingExtraSmall) {
                VectorImage(asset: Asset.iconCheckmark)
                    .accentColor(.rythmicoPurple)
                Text(title)
                    .rythmicoFont(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
            }
        }
    }
}
