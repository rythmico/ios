import SwiftUI

struct AddressLabel: View {
    var address: Address

    var body: some View {
        RythmicoLabel(
            asset: Asset.Icon.Label.location,
            title: Text(address.condensedFormattedString).rythmicoFontWeight(.body)
        )
    }
}
