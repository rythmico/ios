import SwiftUI

struct AddressSelectionView: View {
    var addresses: [Address]
    @Binding var selection: Address?

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
            ForEach(_addresses) { address in
                AddressItemView(
                    title: address.condensedFormattedString,
                    isSelected: self.selection == address
                )
                .onTapGesture { self.selection = address }
            }
        }
    }

    private var _addresses: [Address] {
        if let selectedAddress = selection, !addresses.contains(selectedAddress) {
            selection = nil
        }
        return addresses
    }
}
