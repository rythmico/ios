import SwiftUISugar

struct SelectableContainer<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    let radius: ContainerStyle.OutlineRadius = .medium
    let isSelected: Bool
    @ViewBuilder
    let content: (_ foregroundColor: Color) -> Content

    var body: some View {
        Container(style: style) {
            content(foregroundColor).foregroundColor(foregroundColor)
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
            shape: .squircle(radius: radius.rawValue, style: .continuous),
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
}
