import StudentDO
import SwiftUI

struct AddressLabel: View {
    var address: Address

    var body: some View {
        RythmicoLabel(
            asset: Asset.Icon.Label.location,
            title: Text(address.formatted(style: .multilineCompact)).rythmicoFontWeight(.body)
        )
    }
}
