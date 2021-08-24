import SwiftUIEncore

extension Image {
    static var disclosureIcon: some View {
        Image(systemSymbol: .chevronRight)
            .renderingMode(.template)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.secondary.opacity(0.5))
    }
}
