import SwiftUISugar

final class Teleprompter {
    enum Mode {
        case `static`
        case animated(initialDelay: Double)

        var initialDelay: Double {
            guard case .animated(let initialDelay) = self else { return 0 }
            return initialDelay
        }
    }

    enum Importance: Equatable {
        case transient
        case prominent
    }

    enum Transition: Equatable {
        case moveWithOpacity
        case opacity
        static let `default` = moveWithOpacity

        var anyTransition: AnyTransition {
            switch self {
            case .moveWithOpacity:
                return .offset(y: 70) + .opacity
            case .opacity:
                return .opacity
            }
        }
    }

    // TODO: replace with AttributedString in iOS 15
    struct TextElement: Equatable {
        var style: Font.RythmicoTextStyle? = nil
        let string: String
    }

    init(mode: Mode) {
        self.mode = mode
        self._compoundedDelay = .init(currentValue: mode.initialDelay)
    }

    private let mode: Mode
    @RetainOldValue
    private var compoundedDelay: Double

    @ViewBuilder
    func view<Content: View>(
        transition: Transition = .default,
        importance: Importance,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content().modifier(transitionModifier(transition, importance: importance))
    }

    @ViewBuilder
    func text(
        transition: Transition = .default,
        separator: String = .empty,
        style: Font.RythmicoTextStyle,
        @ArrayBuilder<TextElement> _ elements: () -> [TextElement]
    ) -> some View {
        let elements = elements()
        elements
            .map { Text($0.string).rythmicoFontWeight($0.style ?? style) }
            .joined(separator: Text(separator))
            .rythmicoTextStyle(style)
            .modifier(transitionModifier(transition, for: elements))
    }

    private func transitionModifier(_ transition: Transition, importance: Importance) -> some ViewModifier {
        switch importance {
        case .transient:
            return transitionModifier(transition, importance: importance, compoundingDelay: 0.5)
        case .prominent:
            return transitionModifier(transition, importance: importance, compoundingDelay: 1)
        }
    }

    private func transitionModifier(_ transition: Transition, for elements: [TextElement]) -> some ViewModifier {
        let wordCount = Double(elements.map(\.string).joined().words.count)
        let avgReadingSpeed: Double = 200/60 // avg words per minute / 60 seconds = avg words per second
        let delay = wordCount / avgReadingSpeed
        return transitionModifier(transition, importance: nil, compoundingDelay: delay)
    }

    private func transitionModifier(_ transition: Transition, importance: Importance?, compoundingDelay delay: Double) -> some ViewModifier {
        switch mode {
        case .animated(let initialDelay):
            let deferred: Action
            if importance == .transient {
                let oldCompoundedDelay = compoundedDelay
                let newCompoundedDelay = ($compoundedDelay ?? initialDelay) + delay
                compoundedDelay = newCompoundedDelay
                deferred = { self.compoundedDelay = oldCompoundedDelay + delay }
            } else {
                deferred = { self.compoundedDelay += delay }
            }
            defer { deferred() }
            return OnAppearTransitionModifier(
                transition: transition.anyTransition,
                animation: .rythmicoSpring(duration: .durationMedium).delay(compoundedDelay)
            )
        case .static:
            return OnAppearTransitionModifier(transition: .identity, animation: .none)
        }
    }
}

extension Teleprompter.TextElement: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(style: .none, string: value)
    }
}

func <- (lhs: String, rhs: Font.RythmicoTextStyle) -> Teleprompter.TextElement {
    .init(style: rhs, string: lhs)
}

@propertyWrapper
private struct RetainOldValue<T> {
    /// Old value
    private(set) var projectedValue: T? = nil
    /// Current value
    var wrappedValue: T {
        willSet {
            projectedValue = wrappedValue
        }
    }

    init(currentValue: T) {
        self.wrappedValue = currentValue
    }
}

private struct OnAppearTransitionModifier: ViewModifier {
    let transition: AnyTransition
    let animation: Animation?

    @State private var appeared = false

    func body(content: Content) -> some View {
        ZStack {
            if appeared {
                content.transition(transition)
            }
        }
        .animation(animation, value: appeared)
        .onAppear { appeared = true }
    }
}
