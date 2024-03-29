import SwiftUIEncore
import Combine

final class Teleprompter: ObservableObject {
    enum Mode {
        case `static`
        case animated(initialDelay: Double)

        var initialDelay: Double {
            guard case .animated(let initialDelay) = self else { return 0 }
            return initialDelay
        }
    }

    enum Prominence: Equatable {
        case low
        case normal
        case text(String)
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

    private typealias TransitionModifier = TransitionOnAppearModifier

    // TODO: replace with AttributedString in iOS 15
    struct TextElement: Equatable {
        var style: Font.RythmicoTextStyle? = nil
        let string: String
    }

    // TODO: improve this logic determining finished animations...
    // currently it's time based, which is not the most reliable.
    // AFAIK, SwiftUI lacks a mechanism to watch state `Transaction`s.
    @Published
    private(set) var isFinished = false
    private let start = Date()
    private let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()

    init(mode: Mode) {
        self.mode = mode
        self._compoundedDelay = .init(currentValue: mode.initialDelay)
        switch mode {
        case .animated:
            timer.map { $0.timeIntervalSince(self.start) >= self.compoundedDelay }.filter(\.isTrue).prefix(1).assign(to: &$isFinished)
        case .static:
            isFinished = true
        }
    }

    private let mode: Mode
    @RetainOldValue
    private var compoundedDelay: Double

    @ViewBuilder
    func view<Content: View>(
        transition: Transition? = .default,
        prominence: Prominence,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if let modifier = transitionModifier(transition, prominence: prominence) {
            content().modifier(modifier)
        } else {
            content()
        }
    }

    @ViewBuilder
    func text(
        transition: Transition? = .default,
        separator: String = .empty,
        style: Font.RythmicoTextStyle,
        @ArrayBuilder<TextElement> _ elements: () -> [TextElement]
    ) -> some View {
        let elements = elements()
        let string = elements.map(\.string).joined()
        let view = elements
            .map { Text($0.string).rythmicoFontWeight($0.style ?? style) }
            .joined(separator: Text(separator))
            .rythmicoTextStyle(style)
        if let modifier = transitionModifier(transition, prominence: .text(string)) {
            view.modifier(modifier)
        } else {
            view
        }
    }

    private func transitionModifier(_ transition: Transition?, prominence: Prominence) -> TransitionModifier? {
        switch prominence {
        case .low:
            return transitionModifier(transition, prominence: prominence, compoundingDelay: 0.5)
        case .normal:
            return transitionModifier(transition, prominence: prominence, compoundingDelay: 1)
        case .text(let string):
            let wordCount = Double(string.words.count)
            let avgReadingSpeed: Double = 250/60 // avg words per minute / 60 seconds = avg words per second
            let delay = wordCount / avgReadingSpeed
            return transitionModifier(transition, prominence: nil, compoundingDelay: delay)
        }
    }

    private func transitionModifier(_ transition: Transition?, prominence: Prominence?, compoundingDelay delay: Double) -> TransitionModifier? {
        let deferred: Action?
        defer { deferred?() }

        // Add to compounded delay
        switch (mode, prominence) {
        case (.animated(let initialDelay), .low):
            let oldCompoundedDelay = compoundedDelay
            let newCompoundedDelay = ($compoundedDelay ?? initialDelay) + delay
            compoundedDelay = newCompoundedDelay
            deferred = { self.compoundedDelay = oldCompoundedDelay + delay }
        case (.animated, _):
            deferred = { self.compoundedDelay += delay }
        case (.static, _):
            deferred = nil
        }

        // Return appropriate modifier
        switch (mode, transition) {
        case (.animated, let transition?):
            return TransitionOnAppearModifier(
                transition: transition.anyTransition,
                animation: .rythmicoSpring(duration: .durationMedium).delay(compoundedDelay)
            )
        case (.animated, .none), (.static, _):
            return nil
        }
    }
}

extension Teleprompter.TextElement: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(style: .none, string: value)
    }
}

infix operator <- : AdditionPrecedence

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

private struct TransitionOnAppearModifier: ViewModifier {
    let transition: AnyTransition
    let animation: Animation?

    func body(content: Content) -> some View {
        TransientStateView(from: false, to: true) { appeared in
            ZStack {
                if appeared {
                    content.transition(transition)
                }
            }
            .animation(animation, value: appeared)
        }
    }
}
