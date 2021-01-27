import SwiftUI

struct TutorStatusBanner: View {
    var description: String

    init(_ description: String) {
        self.description = description
    }

    var body: some View {
        VStack(spacing: .spacingUnit * 12) {
            Image(decorative: Asset.appLogo.name)
                .resizable()
                .scaledToFit()
                .frame(width: 68)
            Text(description)
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.center)
                .lineSpacing(.spacingUnit)
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingUnit * 10)
        }
    }

    var foregroundColor: Color {
        Color(
            UIColor(
                lightModeVariant: .init(hex: 0x19212C),
                darkModeVariant: .white
            )
        )
    }
}
