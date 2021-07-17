import SwiftUISugar

extension Image {
    static var calendarIcon: some View {
        Image(systemSymbol: .calendar)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16)
    }
}
