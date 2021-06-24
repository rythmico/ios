import SwiftUI

struct AddressLabel: View {
    var address: Address

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .grid(2)) {
            Image(decorative: Asset.Icon.Label.location.name)
                .renderingMode(.template)
                .offset(y: .grid(0.5))
            Text(address.condensedFormattedString)
                .rythmicoTextStyle(.body)
        }
    }
}
