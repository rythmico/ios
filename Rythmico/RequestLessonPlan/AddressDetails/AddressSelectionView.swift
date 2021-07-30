import SwiftUISugar

struct AddressSelectionView: View {
    var addresses: [Address]
    @Binding var selection: Address?

    var body: some View {
        LazyVStack(alignment: .leading, spacing: .grid(3)) {
            ForEach(_addresses, id: \.hashValue) { address in
                SelectableContainer(
                    address.condensedFormattedString,
                    isSelected: isSelected(address)
                )
                .animation(.rythmicoSpring(duration: .durationMedium), value: isSelected(address))
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

    private func isSelected(_ address: Address) -> Bool {
        selection == address
    }
}
