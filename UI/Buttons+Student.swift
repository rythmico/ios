import SwiftUISugar

extension Button where Label == EmptyView {
    // TODO: refactor RythmicoButton to allow for building this button.
    static func requestLessonPlan(action: @escaping Action) -> some View {
        AdHocButton(action: action) { configuration, _ in
            Container(
                style: .init(
                    fill: configuration.isPressed ? .rythmico.darkPurple : .rythmico.picoteeBlue,
                    shape: .circle,
                    border: .none
                )
            ) {
                Image(decorative: Asset.Icon.Misc.plusMusicNote.name)
                    .renderingMode(.template)
                    .foregroundColor(configuration.isPressed ? .rythmico.inverted(\.foreground) : .rythmico.white)
                    .offset(x: -0.5, y: 1.5)
                    .frame(width: 32, height: 32)
            }
            .shadow(color: .rythmico.resolved(\.foreground, mode: .light).opacity(0.15), radius: 2, x: 0, y: 2)
        }
    }
}

#if DEBUG
struct Buttons_Preview: PreviewProvider {
    static var previews: some View {
        Button.requestLessonPlan(action: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
