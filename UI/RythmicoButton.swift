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
}

extension RythmicoButtonStyle.StateOpacity {
    static let `default` = Self(normal: 1, disabled: 0.5)
}

extension RythmicoButtonStyle {
    private struct SwiftUIButtonStyle<Body: View>: ButtonStyle {
        @Environment(\.isEnabled) private var isEnabled

        @ViewBuilder
        let makeBody: (_ configuration: Configuration, _ isEnabled: Bool) -> Body

        func makeBody(configuration: Configuration) -> Body {
            makeBody(configuration, isEnabled)
        }
    }

    fileprivate var swiftUIButtonStyle: some ButtonStyle {
        SwiftUIButtonStyle(makeBody: { configuration, isEnabled in
            Container(style: style(for: configuration, isEnabled: isEnabled)) {
                configuration.label
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .foregroundColor(foregroundColor(for: configuration, isEnabled: isEnabled))
                    .padding(.horizontal, .grid(3))
                    .frame(maxWidth: maxWidth, minHeight: minHeight)
            }
            .contentShape(Rectangle())
            .opacity(opacity(for: configuration, isEnabled: isEnabled))
        })
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
        case .expansive, .contrained(.medium):
            return 48
        case .contrained(.small):
            return 38
        }
    }
}

extension RythmicoButtonStyle.StateValue: Hashable where T: Hashable {}
extension RythmicoButtonStyle.StateValue: Equatable where T: Equatable {}

extension RythmicoButtonStyle.StateValue {
    func callAsFunction(for configuration: ButtonStyleConfiguration, isEnabled: Bool) -> T {
        switch (configuration.isPressed, isEnabled) {
        case (_, false): return disabled ?? normal
        case (true, _): return pressed ?? normal
        case (false, _): return normal
        }
    }
}
