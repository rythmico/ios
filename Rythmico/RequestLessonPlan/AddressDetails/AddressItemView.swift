import SwiftUI

struct AddressItemView: View {
    var title: String
    var isSelected: Bool

    var body: some View {
        Text(title)
            .rythmicoTextStyle(textStyle)
            .foregroundColor(textColor)
            .minimumScaleFactor(0.9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(.none)
            .modifier(containerModifier.animation(.rythmicoSpring(duration: .durationShort)))
            .contentShape(Rectangle())
    }

    private var textColor: Color {
        isSelected ? .accentColor : .rythmico.foreground
    }

    private var textStyle: Font.RythmicoTextStyle {
        isSelected ? .bodyBold : .body
    }

    private var containerModifier: RoundedThickOutlineContainer {
        isSelected
            ? RoundedThickOutlineContainer(backgroundColor: .accentColor, borderColor: .accentColor)
            : RoundedThickOutlineContainer()
    }
}
