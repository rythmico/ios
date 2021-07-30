import SwiftUISugar

struct SelectableContainer<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    let isSelected: Bool
    @ViewBuilder
    let content: Content

    var body: some View {
        Container(style: style) {
            HStack(spacing: inset) {
                content
                    .foregroundColor(foregroundColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SelectableContainerCheckmark(
                    isSelected: isSelected,
                    foregroundColor: foregroundColor
                )
            }
            .padding(inset)
        }
        .contentShape(Rectangle())
    }

    private var style: ContainerStyle {
        isSelected ? selectedStyle : unselectedStyle
    }

    private var unselectedStyle: ContainerStyle {
        .outline()
    }

    private var selectedStyle: ContainerStyle {
        .init(
            fill: .rythmico.darkPurple,
            shape: .squircle(radius: 8, style: .continuous),
            border: .none
        )
    }

    private var foregroundColor: Color {
        switch (colorScheme, isSelected) {
        case (.light, false):
            return .rythmico.foreground
        case (.light, true):
            return .rythmico.white
        case (.dark, false):
            return .rythmico.foreground
        case (.dark, true):
            return .rythmico.inverted(\.foreground)
        }
    }

    private let inset: CGFloat = .grid(4)
}

extension SelectableContainer where Content == AnyView {
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

struct SelectableContainerCheckmark: View {
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
struct SelectableContainer_Previews: PreviewProvider {
    static var previews: some View {
        let combos = Array(ColorScheme.allCases * Bool.allCases)
        ForEach(0..<combos.count, id: \.self) { index in let combo = combos[index]
            SelectableContainer(
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
