import SwiftUISugar

struct SelectableContainer<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    struct State {
        let backgroundColor: Color
        let foregroundColor: Color
    }

    var fill: Color = .clear
    var radius: ContainerStyle.OutlineRadius = .medium
    let isSelected: Bool
    @ViewBuilder
    let content: (State) -> Content

    var body: some View {
        Container(style: style) {
            content(state).foregroundColor(foregroundColor)
        }
    }

    private var style: ContainerStyle {
        isSelected ? selectedStyle : unselectedStyle
    }

    private var unselectedStyle: ContainerStyle {
        .outline(fill: fill, radius: radius)
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

    private var state: State {
        .init(backgroundColor: style.fill, foregroundColor: foregroundColor)
    }
}
