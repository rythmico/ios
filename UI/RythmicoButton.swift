import SwiftUISugar

struct RythmicoButton<Title: StringProtocol>: View {
    typealias Style = RythmicoButtonStyle

    let title: Title
    let style: Style
    let action: Action?

    init(_ title: Title, style: Style, action: Action?) {
        self.title = title
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action ?? {}) {
            style.mapTitle(Text(title))
        }
        .buttonStyle(style)
    }
}

struct RythmicoButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    enum Layout: Equatable {
        enum ConstrainedSize: Equatable {
            case small
            case medium
        }
        case expansive
        case contrained(ConstrainedSize)
    }

    struct StateValue<T> {
        var normal: T
        var pressed: T? = nil
        var disabled: T? = nil

        func callAsFunction(for configuration: ButtonStyleConfiguration, isEnabled: Bool) -> T {
            switch (configuration.isPressed, isEnabled) {
            case (_, false): return disabled ?? normal
            case (true, _): return pressed ?? normal
            case (false, _): return normal
            }
        }
    }

    typealias StateColor = StateValue<Color>
    typealias StateOpacity = StateValue<Double>

    let shape: ContainerStyle.Shape
    let layout: Layout
    let mapTitle: (Text) -> AnyView
    let foregroundColor: StateColor
    let backgroundColor: StateColor
    let borderColor: StateColor
    var opacity: StateOpacity = .default

    func makeBody(configuration: Configuration) -> some View {
        Container(style: style(for: configuration)) {
            configuration.label
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundColor(foregroundColor(for: configuration, isEnabled: isEnabled))
                .padding(.horizontal, .grid(3))
                .frame(maxWidth: maxWidth, minHeight: minHeight)
        }
        .contentShape(Rectangle())
        .opacity(opacity(for: configuration, isEnabled: isEnabled))
    }

    func style(for configuration: Configuration) -> ContainerStyle {
        ContainerStyle(
            fill: backgroundColor(for: configuration, isEnabled: isEnabled),
            shape: shape,
            border: .init(color: borderColor(for: configuration, isEnabled: isEnabled), width: 2)
        )
    }

    var maxWidth: CGFloat? {
        layout == .expansive ? .grid(85) : nil
    }

    var minHeight: CGFloat {
        switch layout {
        case .expansive, .contrained(.medium):
            return 48
        case .contrained(.small):
            return 38
        }
    }
}

extension RythmicoButtonStyle.StateOpacity {
    static let `default` = Self(normal: 1, disabled: 0.5)
}
