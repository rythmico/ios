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
        AdHocButtonStyle { label, state in
            Container(style: style(for: state)) {
                label
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .foregroundColor(foregroundColor(for: state))
                    .padding(.horizontal, .grid(3))
                    .frame(maxWidth: maxWidth, minHeight: minHeight)
            }
            .opacity(opacity(for: state, fallbackValues: [\.disabled: 0.3]))
        }
    }

    private func style(for state: AdHocButtonState) -> ContainerStyle {
        ContainerStyle(
            fill: backgroundColor(for: state),
            shape: shape,
            border: .init(color: borderColor(for: state), width: 2)
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

    func callAsFunction(for state: AdHocButtonState, fallbackValues: FallbackValues = [:]) -> T {
        state.map(
            normal: normal,
            pressed: pressed ?? fallbackValues[\.pressed],
            disabled: disabled ?? fallbackValues[\.disabled]
        )
    }
}

extension RythmicoButtonStyle.Layout {
    func map<T>(
        expansive: @autoclosure () -> T,
        constrainedM: @autoclosure () -> T? = nil,
        constrainedS: @autoclosure () -> T? = nil,
        constrainedXS: @autoclosure () -> T? = nil
    ) -> T {
        switch self {
        case .expansive:
            return expansive()
        case .constrained(.m):
            return constrainedM() ?? expansive()
        case .constrained(.s):
            return constrainedS() ?? constrainedM() ?? expansive()
        case .constrained(.xs):
            return constrainedXS() ?? constrainedS() ?? constrainedM() ?? expansive()
        }
    }
}
