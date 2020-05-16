import SwiftUI

struct AddressSelectionView: View {
    var addresses: [AddressDetails]
    @Binding var selection: AddressDetails?

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
            ForEach(_addresses, id: \.hashValue) { address in
                AddressItemView(
                    title: address.condensedFormattedString,
                    isSelected: self.selection == address
                )
                .onTapGesture { self.selection = address }
            }
        }
    }

    private var _addresses: [AddressDetails] {
        if let selectedAddress = selection, !addresses.contains(selectedAddress) {
            selection = nil
        }
        return addresses
    }
}
