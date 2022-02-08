import SwiftUIEncore

struct SelectableContainerState: Hashable {
    let isSelected: Bool
    let backgroundColor: Color?
    let foregroundColor: Color
}

struct SelectableContainer<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    typealias Fill = ContainerStyle.Fill
    typealias Radius = ContainerStyle.OutlineRadius
    typealias State = SelectableContainerState

    var fill: Fill
    var radius: Radius
    var borderColor: Color
    let isSelected: Bool
    @ViewBuilder
    let content: (State) -> Content

    private var fillColor: Color?

    init<SomeFill: ShapeStyle>(
        fill: SomeFill,
        radius: Radius = .default,
        borderColor: Color = ContainerStyle.outlineBorderColor,
        isSelected: Bool,
        @ViewBuilder content: @escaping (State) -> Content
    ) {
        self.fill = AnyShapeStyle(fill)
        self.fillColor = fill as? Color
        self.radius = radius
        self.borderColor = borderColor
        self.isSelected = isSelected
        self.content = content
    }

    init(
        radius: Radius = .default,
        borderColor: Color = ContainerStyle.outlineBorderColor,
        isSelected: Bool,
        @ViewBuilder content: @escaping (State) -> Content
    ) {
        self.init(fill: .clear, radius: radius, borderColor: borderColor, isSelected: isSelected, content: content)
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
            fill: Color.rythmico.darkPurple,
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
            backgroundColor: fillColor,
            foregroundColor: foregroundColor
        )
    }
}
