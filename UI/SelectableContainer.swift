import SwiftUISugar

struct SelectableContainerState: Hashable {
    let isSelected: Bool
    let backgroundColor: Color?
    let foregroundColor: Color
}

struct SelectableContainer<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    typealias Fill = ContainerStyle.Fill
    typealias State = SelectableContainerState

    var fill: Fill
    var radius: ContainerStyle.OutlineRadius
    var borderColor: Color
    let isSelected: Bool
    @ViewBuilder
    let content: (State) -> Content

    init(
        fill: Fill = .color(.clear),
        radius: ContainerStyle.OutlineRadius = .default,
        borderColor: Color = ContainerStyle.outlineBorderColor,
        isSelected: Bool,
        @ViewBuilder content: @escaping (State) -> Content
    ) {
        self.fill = fill
        self.radius = radius
        self.borderColor = borderColor
        self.isSelected = isSelected
        self.content = content
    }

    init(
        fill: Color,
        radius: ContainerStyle.OutlineRadius = .default,
        borderColor: Color = ContainerStyle.outlineBorderColor,
        isSelected: Bool,
        @ViewBuilder content: @escaping (State) -> Content
    ) {
        self.init(fill: .color(fill), radius: radius, borderColor: borderColor, isSelected: isSelected, content: content)
    }

    init(
        fill: LinearGradient,
        radius: ContainerStyle.OutlineRadius = .default,
        borderColor: Color = ContainerStyle.outlineBorderColor,
        isSelected: Bool,
        @ViewBuilder content: @escaping (State) -> Content
    ) {
        self.init(fill: .linearGradient(fill), radius: radius, borderColor: borderColor, isSelected: isSelected, content: content)
    }

    var body: some View {
        Container(style: style) {
            content(state).foregroundColor(foregroundColor)
        }
    }

    private var style: ContainerStyle {
        isSelected ? selectedStyle : unselectedStyle
    }

    private var unselectedStyle: ContainerStyle {
        .outline(fill: fill, radius: radius, borderColor: borderColor)
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
        .init(
            isSelected: isSelected,
            backgroundColor: style.fill.color,
            foregroundColor: foregroundColor
        )
    }
}
