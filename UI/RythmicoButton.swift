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
        .buttonStyle(style.swiftUIButtonStyle)
    }
}

struct RythmicoButtonStyle {
    enum Layout: Equatable {
        enum ConstrainedSize: Equatable {
            case m
            case s
            case xs
        }
        case expansive
        case constrained(ConstrainedSize)
    }

    struct StateValue<T> {
        var normal: T
        var pressed: T? = nil
        var disabled: T? = nil
    }

    typealias StateColor = StateValue<Color>
    typealias StateOpacity = StateValue<Double>

    let shape: ContainerStyle.Shape
    let layout: Layout
    let mapTitle: (Text) -> AnyView
    let foregroundColor: StateColor
    let backgroundColor: StateColor
    let borderColor: StateColor
    var opacity: StateOpacity = .init(normal: 1)
}

extension RythmicoButtonStyle {
    fileprivate var swiftUIButtonStyle: some ButtonStyle {
        AdHocButtonStyle { configuration, isEnabled in
            Container(style: style(for: configuration, isEnabled: isEnabled)) {
                configuration.label
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .foregroundColor(foregroundColor(for: configuration, isEnabled: isEnabled))
                    .padding(.horizontal, .grid(3))
                    .frame(maxWidth: maxWidth, minHeight: minHeight)
            }
            .contentShape(Rectangle())
            .opacity(opacity(for: configuration, isEnabled: isEnabled, fallbackValues: [\.disabled: 0.5]))
        }
    }

    private func style(for configuration: ButtonStyleConfiguration, isEnabled: Bool) -> ContainerStyle {
        ContainerStyle(
            fill: backgroundColor(for: configuration, isEnabled: isEnabled),
            shape: shape,
            border: .init(color: borderColor(for: configuration, isEnabled: isEnabled), width: 2)
        )
    }

    private var maxWidth: CGFloat? {
        layout == .expansive ? .grid(85) : nil
    }

    private var minHeight: CGFloat {
        switch layout {
        case .expansive, .constrained(.m):
            return 48
        case .constrained(.s):
            return 38
        case .constrained(.xs):
            return 32
        }
    }
}

extension RythmicoButtonStyle.StateValue: Hashable where T: Hashable {}
extension RythmicoButtonStyle.StateValue: Equatable where T: Equatable {}

extension RythmicoButtonStyle.StateValue {
    typealias FallbackValues = [KeyPath<Self, T?>: T]

    func callAsFunction(
        for configuration: ButtonStyleConfiguration,
        isEnabled: Bool,
        fallbackValues: FallbackValues = [:]
    ) -> T {
        switch (configuration.isPressed, isEnabled) {
        case (_, false): return disabled ?? fallbackValues[\.disabled] ?? normal
        case (true, _): return pressed ?? fallbackValues[\.pressed] ?? normal
        case (false, _): return normal
        }
    }
}

extension RythmicoButtonStyle.Layout {
    func map<T>(
        expansive: T,
        constrainedM: T? = nil,
        constrainedS: T? = nil,
        constrainedXS: T? = nil
    ) -> T {
        switch self {
        case .expansive:
            return expansive
        case .constrained(.m):
            return constrainedM ?? expansive
        case .constrained(.s):
            return constrainedS ?? constrainedM ?? expansive
        case .constrained(.xs):
            return constrainedXS ?? constrainedS ?? constrainedM ?? expansive
        }
    }
}
