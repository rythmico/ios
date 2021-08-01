import SwiftUISugar

extension Image {
    static var calendarIcon: some View {
        Image(systemSymbol: .calendar)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16)
    }

    static func checkmarkIcon(color: Color) -> some View {
        Image(decorative: Asset.Icon.Misc.checkmark.name)
            .renderingMode(.template)
            .foregroundColor(color)
    }
}
