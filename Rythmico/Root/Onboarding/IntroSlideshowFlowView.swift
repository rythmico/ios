import SwiftUISugar

extension ContentSizeCategory: Comparable {}

struct IntroSlideshowFlowView<EndButton: View>: View {
    @Environment(\.sizeCategory) private var sizeCategory

    private let teleprompter = Teleprompter(mode: .animated(initialDelay: 2))

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
