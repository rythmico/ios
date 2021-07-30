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
            Text(title).rythmicoTextStyle(style.textStyle)
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

    let layout: Layout
    let textStyle: Font.RythmicoTextStyle
    let foregroundColor: StateColor
    let backgroundColor: StateColor
    let borderColor: StateColor
    var opacity: StateOpacity = .init(normal: 1)

    func makeBody(configuration: Configuration) -> some View {
        Container(style: style(for: configuration)) {
            configuration.label
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .padding(.horizontal, .grid(3))
                .foregroundColor(foregroundColor(for: configuration, isEnabled: isEnabled))
                .opacity(opacity(for: configuration, isEnabled: isEnabled))
                .frame(maxWidth: maxWidth, minHeight: minHeight)
        }
        .contentShape(Rectangle())
    }

    func style(for configuration: Configuration) -> ContainerStyle {
        ContainerStyle(
            background: backgroundColor(for: configuration, isEnabled: isEnabled),
            corner: .init(rounding: .continuous, radius: 4),
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
