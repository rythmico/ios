import SwiftUISugar

struct OptionsButton: View {
    enum Size: CGFloat {
        case small = 22
        case medium = 26
    }

    let size: Size
    let buttons: [ContextMenuButton]

    init(size: Size, _ buttons: [ContextMenuButton]) {
        self.size = size
        self.buttons = buttons
    }

    var body: some View {
        ContextMenuView(buttons) { ThreeDotButton(size: size, action: {}) }
    }
}

private struct ThreeDotButton: View {
    let size: OptionsButton.Size
    let action: () -> Void

    var body: some View {
        AdHocButton(action: action) { state in
            Container(style: style(for: state)) {
                ZStack {
                    Image(systemSymbol: .ellipsis)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.7)
                        .foregroundColor(foregroundColor(for: state))
                }
                .frame(width: width, height: width)
            }
        }
    }

    private var width: CGFloat { size.rawValue }

    private func style(for state: AdHocButtonState) -> ContainerStyle {
        .init(
            fill: state.map(normal: .rythmico.picoteeBlue, pressed: .rythmico.darkPurple),
            shape: .circle,
            border: .none
        )
    }

    private func foregroundColor(for state: AdHocButtonState) -> Color {
        state.map(normal: .rythmico.white, pressed: .rythmico.inverted(\.foreground))
    }
}

#if DEBUG
struct ThreeDotButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ThreeDotButton(size: .small, action: {})
            ThreeDotButton(size: .medium, action: {})
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .backgroundColor(.rythmico.background)
//        .environment(\.colorScheme, .dark)
    }
}
#endif
