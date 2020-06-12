import SwiftUI

struct AddressItemView: View {
    var title: String
    var isSelected: Bool

    var body: some View {
        Text(title)
            .rythmicoFont(textStyle)
            .foregroundColor(textColor)
            .minimumScaleFactor(0.9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(.none)
            .modifier(containerModifier.animation(.rythmicoSpring(duration: .durationShort)))
            .contentShape(Rectangle())
    }

    private var textColor: Color {
        isSelected ? .accentColor : .rythmicoGray90
    }

    private var textStyle: RythmicoFontStyle {
        isSelected ? .bodyBold : .body
    }

    private var containerModifier: RoundedThickOutlineContainer {
        isSelected
            ? RoundedThickOutlineContainer(backgroundColor: .accentColor, borderColor: .accentColor)
            : RoundedThickOutlineContainer()
    }
}
