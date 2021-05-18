import SwiftUI

struct AddressLabel: View {
    var address: Address

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .spacingUnit * 2) {
            Image(decorative: Asset.Icon.Label.location.name)
                .renderingMode(.template)
                .offset(y: .spacingUnit / 2)
            Text(address.condensedFormattedString)
                .rythmicoTextStyle(.body)
        }
    }
}
