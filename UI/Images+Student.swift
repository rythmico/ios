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

    static var requestLessonPlanIcon: some View {
        Container(
            style: .init(
                fill: .rythmico.picoteeBlue,
                shape: .circle,
                border: .none
            )
        ) {
            Image(decorative: Asset.Icon.Misc.plusMusicNote.name)
                .renderingMode(.template)
                .foregroundColor(.rythmico.white)
                .offset(x: -0.5, y: 1.5)
                .frame(width: 32, height: 32)
        }
        .shadow(color: .rythmico.resolved(\.foreground, mode: .light).opacity(0.15), radius: 2, x: 0, y: 2)
    }
}
