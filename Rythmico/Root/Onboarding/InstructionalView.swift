import SwiftUISugar

struct InstructionalView<EndButton: View>: View {
    @Environment(\.appSplashNamespace) private var appSplashNamespace
    @Environment(\.sizeCategory) private var sizeCategory

    enum Headline {
        case welcome
        case whatIsRythmico
    }

    private let headline: Headline
    private let teleprompter: Teleprompter
    private let endButton: EndButton

    init(headline: Headline, animated: Bool, @ViewBuilder endButton: () -> EndButton) {
        self.headline = headline
        self.teleprompter = Teleprompter(mode: animated ? .animated(initialDelay: 2) : .static)
        self.endButton = endButton()
    }

    var body: some View {
        VStack(spacing: spacing) {
            VStack(spacing: spacing) {
                teleprompter.view(transition: .none, prominence: .normal) {
                    Image.rythmicoLogo(width: 40, namespace: appSplashNamespace)
                }

                if let headline = headline {
                    teleprompter.view(transition: .none, prominence: .text(headline.string)) {
                        Text(headline.string)
                            .rythmicoTextStyle(.headline)
                            .lineLimit(1)
                            .ifLet(appSplashNamespace) { $0.matchedGeometryEffect(id: AppSplash.NamespaceTitleId(), in: $1) }
                    }
                }
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
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, .grid(6))

            teleprompter.view(transition: .opacity, prominence: .normal) {
                endButton.padding(.horizontal, .grid(5))
            }
        }
        .foregroundColor(.rythmico.foreground)
        .minimumScaleFactor(0.5)
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

private extension InstructionalView.Headline {
    var stringFragment: String? {
        switch self {
        case .welcome:
            return "Rythmico"
        case .whatIsRythmico:
            return nil
        }
    }

    var string: String {
        switch self {
        case .welcome:
            return "Welcome to Rythmico"
        case .whatIsRythmico:
            return "What is Rythmico?"
        }
    }
}

#if DEBUG
struct InstructionalView_Preview: PreviewProvider {
    static var previews: some View {
        InstructionalView(headline: .whatIsRythmico, animated: false) {
            RythmicoButton("Done", style: .secondary(), action: nil)
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
