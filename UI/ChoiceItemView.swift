import SwiftUISugar

struct ChoiceItemView<Content: View>: View {
    let isSelected: Bool
    @ViewBuilder
    let content: (SelectableContainerState) -> Content

    var body: some View {
        SelectableContainer(isSelected: isSelected) { state in
            HStack(spacing: inset) {
                content(state).frame(maxWidth: .infinity, alignment: .leading)
                ChoiceItemCheckmarkView(
                    isSelected: state.isSelected,
                    foregroundColor: state.foregroundColor
                )
            }
            .padding(inset)
        }
    }

    private let inset: CGFloat = .grid(4)
}

struct ChoiceItemCheckmarkView: View {
    @Environment(\.colorScheme) private var colorScheme

    let isSelected: Bool
    let foregroundColor: Color

    var body: some View {
        Container(style: style) {
            Image.checkmarkIcon(color: .rythmico.darkPurple)
                .opacity(isSelected ? 1 : 0)
                .frame(width: 24, height: 24)
        }
    }

    private var style: ContainerStyle {
        isSelected ? selectedStyle : unselectedStyle
    }

    private var unselectedStyle: ContainerStyle {
        .init(fill: .clear, shape: .circle, border: .init(color: .rythmico.outline, width: 2.25))
    }

    private var selectedStyle: ContainerStyle {
        .init(fill: foregroundColor, shape: .circle, border: .none)
    }
}

#if DEBUG
struct SelectableItemView_Previews: PreviewProvider {
    static var previews: some View {
        let combos = Array(ColorScheme.allCases * Bool.allCases)
        ForEach(0..<combos.count, id: \.self) { index in let combo = combos[index]
            ChoiceItemView(isSelected: combo.1) { state in
                Text(
                    """
                    House No. 2,  Lorem ipsum dolor,
                    London, E2 2FA
                    """
                )
                .rythmicoTextStyle(state.isSelected ? .bodyBold : .bodyMedium)
            }
            .padding()
            .background(combo.0 == .dark ? Color(.systemGray6) : .white)
            .environment(\.colorScheme, combo.0)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
