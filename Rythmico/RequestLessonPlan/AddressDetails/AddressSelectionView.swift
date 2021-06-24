import SwiftUI

struct AddressSelectionView: View {
    var addresses: [Address]
    @Binding var selection: Address?

    var body: some View {
        LazyVStack(alignment: .leading, spacing: .grid(3)) {
            ForEach(_addresses, id: \.hashValue) { address in
                AddressItemView(
                    title: address.condensedFormattedString,
                    isSelected: selection == address
                )
                .onTapGesture { selection = address }
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
