import SwiftUIEncore

// TODO: refactor RythmicoButton to allow for building these buttons.
extension Button where Label == EmptyView {
    static func requestLessonPlan(action: @escaping Action) -> some View {
        CustomButton(action: action) { state in
            Container(
                style: .init(
                    fill: state.map(normal: .rythmico.picoteeBlue, pressed: .rythmico.darkPurple),
                    shape: .circle,
                    border: .none
                )
            ) {
                Image(decorative: Asset.Icon.Misc.plusMusicNote.name)
                    .renderingMode(.template)
                    .foregroundColor(state.map(normal: .rythmico.white, pressed: .rythmico.inverted(\.foreground)))
                    .offset(x: -0.5, y: 1.5)
                    .frame(width: 32, height: 32)
            }
            .shadow(color: .rythmico.resolved(\.foreground, mode: .light).opacity(0.15), radius: 2, x: 0, y: 2)
        }
    }

    static func help(action: @escaping Action) -> some View {
        CustomButton(action: action) { state in
            Container(
                style: .init(
                    fill: state.map(normal: .rythmico.picoteeBlue, pressed: .rythmico.darkPurple),
                    shape: .circle,
                    border: .none
                )
            ) {
                Image(systemSymbol: .questionmark)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(state.map(normal: .rythmico.white, pressed: .rythmico.inverted(\.foreground)))
                    .offset(x: 0.5)
                    .frame(width: 32, height: 32)
            }
            .shadow(color: .rythmico.resolved(\.foreground, mode: .light).opacity(0.15), radius: 2, x: 0, y: 2)
        }
    }
}

#if DEBUG
struct Buttons_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            Button.requestLessonPlan(action: {})
            Button.help(action: {})
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
