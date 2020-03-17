import SwiftUI

struct AddressSelectionView: View {
    var addresses: [Address]
    @Binding var selection: Address?

    var body: some View {
        VStack(spacing: .spacingExtraSmall) {
            ForEach(_addresses) { address in
                HStack {
                    Text(address.singleLineFormattedString)
                        .rythmicoFont(self.textStyle(for: address))
                        .foregroundColor(self.textColor(for: address))
                        .animation(.none)
                    Spacer()
                }
                .modifier(
                    self.containerModifier(for: address)
                        .animation(.easeInOut(duration: .durationShort))
                )
                .contentShape(Rectangle())
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

    private func textColor(for address: Address) -> Color {
        selection == address ? .accentColor : .rythmicoGray90
    }

    private func textStyle(for address: Address) -> Font.TextStyle {
        selection == address ? .callout : .body
    }

    private func containerModifier(for address: Address) -> RoundedThickOutlineContainer {
        selection == address
            ? RoundedThickOutlineContainer(backgroundColor: .accentColor, borderColor: .accentColor)
            : RoundedThickOutlineContainer()
    }
}
