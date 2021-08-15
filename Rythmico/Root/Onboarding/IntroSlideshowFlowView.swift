import SwiftUISugar

extension ContentSizeCategory: Comparable {}

final class TeleprompterCoordinator {
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

    init(initialDelay: Double = 0) {
        self.compoundedDelay = initialDelay
    }

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
        lineLimit: Int? = nil,
        @ArrayBuilder<TextElement> _ elements: () -> [TextElement]
    ) -> some View {
        let elements = elements()
        elements
            .map { Text($0.string).rythmicoFontWeight($0.style ?? style) }
            .joined(separator: Text(separator))
            .rythmicoTextStyle(style)
            .lineLimit(lineLimit)
            .minimumScaleFactor(lineLimit == nil ? 1 : 0.5)
            .modifier(transitionModifier(transition, for: elements))
    }

    private func transitionModifier(_ transition: Transition, importance: Importance) -> some ViewModifier {
        switch importance {
        case .transient:
            return transitionModifier(transition, compoundingDelay: 0.5)
        case .prominent:
            return transitionModifier(transition, compoundingDelay: 1)
        }
    }

    private func transitionModifier(_ transition: Transition, for elements: [TextElement]) -> some ViewModifier {
        let wordCount = Double(elements.map(\.string).joined().words.count)
        let avgReadingSpeed: Double = 200/60 // avg words per minute / 60 seconds = avg words per second
        let delay = wordCount / avgReadingSpeed
        return transitionModifier(transition, compoundingDelay: delay)
    }

    private func transitionModifier(_ transition: Transition, compoundingDelay delay: Double) -> some ViewModifier {
        defer { compoundedDelay += delay }
        return OnAppearTransitionModifier(
            transition: transition.anyTransition,
            animation: .rythmicoSpring(duration: .durationMedium).delay(compoundedDelay)
        )
    }
}

extension TeleprompterCoordinator.TextElement: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(style: .none, string: value)
    }
}

func <- (lhs: String, rhs: Font.RythmicoTextStyle) -> TeleprompterCoordinator.TextElement {
    .init(style: rhs, string: lhs)
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

struct IntroSlideshowFlowView<EndButton: View>: View {
    @Environment(\.sizeCategory) private var sizeCategory

    private let teleprompter = TeleprompterCoordinator(initialDelay: 2)

    @ViewBuilder
    var endButton: () -> EndButton

    var body: some View {
        VStack(spacing: spacing) {
            VStack(spacing: spacing) {
                teleprompter.view(importance: .prominent) {
                    Image(decorative: Asset.Logo.rythmico.name).resizable().aspectRatio(contentMode: .fit).frame(width: 40)
                }
                teleprompter.text(style: .headline, lineLimit: 1) {
                    "Welcome to Rythmico"
                }
                teleprompter.text(style: .subheadline) {
                    "Rythmico is a first-class music tutoring marketplace."
                }
                teleprompter.view(importance: .transient) {
                    HDivider().frame(width: 80)
                }
                teleprompter.text(style: .subheadline) {
                    "The booking process is "
                    "simple" <- .subheadlineBold
                    " and "
                    "convenient" <- .subheadlineBold
                    "."
                }
                teleprompter.text(style: .subheadline) {
                    "Instead of having to look through dozens of tutor profiles, simply "
                    "specify your requirements" <- .subheadlineBold
                    " for a "
                    "weekly lesson plan" <- .subheadlineBold
                    " and have our top-tier tutors apply for your consideration."
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, .grid(6))

            teleprompter.view(transition: .opacity, importance: .prominent) {
                endButton().padding(.horizontal, .grid(5))
            }
        }
        .backgroundColor(.rythmico.background)
        .minimumScaleFactor(0.5)
        .foregroundColor(.rythmico.foreground)
        .multilineTextAlignment(.center)
        .padding(.vertical, spacing)
        .environment(\.sizeCategory, min(sizeCategory, maxSizeCategory))
    }

    private var spacing: CGFloat {
        isCompact ? .grid(4) : .grid(5)
    }

    private var maxSizeCategory: ContentSizeCategory {
        isCompact ? .extraExtraLarge : .extraExtraExtraLarge
    }

    private var isCompact: Bool {
        UIScreen.main.bounds.height <= 568 // iPhone 5/SE size.
    }
}

#if DEBUG
struct IntroSlideshowFlowView_Preview: PreviewProvider {
    static var previews: some View {
        IntroSlideshowFlowView {
            RythmicoButton("Done", style: .secondary(), action: nil)
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
