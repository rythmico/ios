import SwiftUIEncore

struct OptionsButton: View {
    enum Size: CGFloat {
        case small = 22
        case medium = 26
    }

    let size: Size
    let padding: CGFloat
    let buttons: [ContextMenuButton]

    init(size: Size, padding: CGFloat = 0, _ buttons: [ContextMenuButton]) {
        self.size = size
        self.padding = padding
        self.buttons = buttons
    }

    var body: some View {
        ContextMenuView(buttons) {
            ThreeDotButton(size: size, padding: padding, action: {})
        }
    }
}

private struct ThreeDotButton: View {
    let size: OptionsButton.Size
    let padding: CGFloat
    let action: () -> Void

    var body: some View {
        CustomButton(action: action) { state in
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
            .padding(padding) // hackish way to allow for a larger tap area... haven't found any other solution so far.
        }
    }

    private var width: CGFloat { size.rawValue }

    private func style(for state: CustomButtonState) -> ContainerStyle {
        .init(
            fill: state.map(normal: .rythmico.picoteeBlue, pressed: .rythmico.darkPurple),
            shape: .circle,
            border: .none
        )
    }

    private func foregroundColor(for state: CustomButtonState) -> Color {
        state.map(normal: .rythmico.white, pressed: .rythmico.inverted(\.foreground))
    }
}

#if DEBUG
struct ThreeDotButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ThreeDotButton(size: .small, padding: 0, action: {})
            ThreeDotButton(size: .medium, padding: 0, action: {})
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .backgroundColor(.rythmico.background)
//        .environment(\.colorScheme, .dark)
    }
}
#endif
