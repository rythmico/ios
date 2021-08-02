import SwiftUISugar

struct SelectableItemView<Content: View>: View {
    let isSelected: Bool
    @ViewBuilder
    let content: Content

    var body: some View {
        SelectableContainer(isSelected: isSelected) { foregroundColor in
            HStack(spacing: inset) {
                content.frame(maxWidth: .infinity, alignment: .leading)
                SelectableItemCheckmarkView(
                    isSelected: isSelected,
                    foregroundColor: foregroundColor
                )
            }
            .padding(inset)
        }
    }

    private let inset: CGFloat = .grid(4)
}

extension SelectableItemView where Content == AnyView {
    init<Title: StringProtocol>(_ title: Title, isSelected: Bool) {
        self.init(isSelected: isSelected) {
            AnyView(
                Text(title)
                    .rythmicoTextStyle(isSelected ? .bodyBold : .bodyMedium)
                    .minimumScaleFactor(0.7)
            )
        }
    }
}

struct SelectableItemCheckmarkView: View {
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
            SelectableItemView(
                """
                House No. 2,  Lorem ipsum dolor,
                London, E2 2FA
                """,
                isSelected: combo.1
            )
            .padding()
            .background(combo.0 == .dark ? Color(.systemGray6) : .white)
            .environment(\.colorScheme, combo.0)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
