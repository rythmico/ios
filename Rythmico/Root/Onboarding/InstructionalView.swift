import SwiftUIEncore

enum InstructionalViewContent {
    case welcome
    case loggedOut
    case whatIsRythmico
}

struct InstructionalView<EndButton: View>: View {
    @Environment(\.appSplashNamespace) private var appSplashNamespace
    @Environment(\.sizeCategory) private var sizeCategory

    typealias Content = InstructionalViewContent

    private let content: Content
    @StateObject
    private var teleprompter: Teleprompter
    private let initialDelay: Double?
    private let endButton: EndButton

    init(_ content: Content, animated: Bool, @ViewBuilder endButton: () -> EndButton) {
        self.content = content
        let initialDelay = animated ? AppView.Const.splashToOnboardingAnimationElapseTime : nil
        self._teleprompter = .init(wrappedValue: Teleprompter(mode: initialDelay.map(Teleprompter.Mode.animated) ?? .static))
        self.initialDelay = initialDelay
        self.endButton = endButton()
    }

    var body: some View {
        VStack(spacing: spacing) {
            VStack(spacing: spacing) {
                teleprompter.view(transition: .none, prominence: .normal) {
                    Image.rythmicoLogo(width: 40, namespace: appSplashNamespace)
                }
                teleprompter.view(transition: .none, prominence: .text(content.headlineString)) {
                    headlineView.lineLimit(1)
                }
                switch content {
                case .welcome, .whatIsRythmico:
                    teleprompter.text(style: .subheadline) {
                        "Rythmico is a first-class music tutoring marketplace."
                    }
                    teleprompter.view(prominence: .low) {
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
                case .loggedOut:
                    EmptyView()
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, .grid(6))

            teleprompter.view(transition: .opacity, prominence: .normal) {
                endButton.padding(.horizontal, .grid(5))
            }
        }
        .disabled(!teleprompter.isFinished)
        .foregroundColor(.rythmico.foreground)
        .minimumScaleFactor(0.5)
        .multilineTextAlignment(.center)
        .padding(.vertical, spacing)
        .environment(\.sizeCategory, min(sizeCategory, maxSizeCategory))
    }

    @ViewBuilder
    private var headlineView: some View {
        switch content {
        case .welcome:
            TransientContentView(
                delay: initialDelay,
                from: { regularHeadlineView(content.headlineFragments.1) },
                to: { animatedHeadlineView(content.headlineFragments) }
            )
        case .loggedOut,
             .whatIsRythmico:
            regularHeadlineView(content.headlineString)
        }
    }

    @ViewBuilder
    private func regularHeadlineView(_ string: String) -> some View {
        Text(string)
            .rythmicoTextStyle(.headline)
            .matchedGeometryEffect(id: AppSplash.NamespaceTitleId(), in: appSplashNamespace)
    }

    @ViewBuilder
    private func animatedHeadlineView(_ fragments: (String, String)) -> some View {
        TransientStateView(delay: .durationMedium, from: .right, to: .none) { (anchor: TwoSidedText.Anchor?) in
            TwoSidedText(content.headlineFragments.0, content.headlineFragments.1, style: .headline, anchor: anchor)
        }
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

private extension InstructionalViewContent {
    var headlineString: String { headlineFragments.0 + headlineFragments.1 }
    var headlineFragments: (String, String) {
        switch self {
        case .welcome:
            return ("Welcome to ", "Rythmico")
        case .loggedOut:
            return ("Welcome", .empty)
        case .whatIsRythmico:
            return ("What is Rythmico?", .empty)
        }
    }
}

#if DEBUG
struct InstructionalView_Preview: PreviewProvider {
    static var previews: some View {
        InstructionalView(.whatIsRythmico, animated: false) {
            RythmicoButton("Done", style: .secondary(), action: nil)
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
