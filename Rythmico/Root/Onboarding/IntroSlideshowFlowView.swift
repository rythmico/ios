import SwiftUISugar

extension ContentSizeCategory: Comparable {}

struct OnAppearTransitionModifier: ViewModifier {
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

extension View {
    func onAppearTransition(_ transition: AnyTransition, animation: Animation? = .none) -> some View {
        self.modifier(OnAppearTransitionModifier(transition: transition, animation: animation))
    }
}

struct IntroSlideshowFlowView<EndButton: View>: View {
    @Environment(\.sizeCategory) private var sizeCategory

    @ViewBuilder
    var endButton: () -> EndButton

    var body: some View {
        VStack(spacing: spacing) {
            VStack(spacing: spacing) {
                Image(decorative: Asset.Logo.rythmico.name).resizable().aspectRatio(contentMode: .fit).frame(width: 40)
                    .modifier(onAppearOffsetTransitionModifier(delay: 2))
                Text("Welcome to Rythmico")
                    .rythmicoTextStyle(.headline)
                    .lineLimit(1)
                    .modifier(onAppearOffsetTransitionModifier(delay: 3))
                Text("Rythmico is a first-class music tutoring marketplace.")
                    .rythmicoTextStyle(.subheadline)
                    .modifier(onAppearOffsetTransitionModifier(delay: 4))

                HDivider().frame(width: 80).modifier(onAppearOpacityTransitionModifier(delay: 4.5))
                Text {
                    "The booking process is "
                    "simple".text.rythmicoFontWeight(.subheadlineBold)
                    " and "
                    "convenient".text.rythmicoFontWeight(.subheadlineBold)
                    "."
                }
                .rythmicoTextStyle(.subheadline)
                .modifier(onAppearOffsetTransitionModifier(delay: 6))

                Text {
                    "Instead of having to look through dozens of tutor profiles, simply "
                    "specify your requirements".text.rythmicoFontWeight(.subheadlineBold)
                    " for a "
                    "weekly lesson plan".text.rythmicoFontWeight(.subheadlineBold)
                    " and have our top-tier tutors apply for your consideration."
                }
                .rythmicoTextStyle(.subheadline)
                .modifier(onAppearOffsetTransitionModifier(delay: 9))
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, .grid(6))

            endButton().padding(.horizontal, .grid(5)).modifier(onAppearOpacityTransitionModifier(delay: 13.5))
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

    private func onAppearOffsetTransitionModifier(delay: Double = 0) -> some ViewModifier {
        OnAppearTransitionModifier(
            transition: .offset(y: 70) + .opacity,
            animation: .rythmicoSpring(duration: .durationMedium).delay(delay)
        )
    }

    private func onAppearOpacityTransitionModifier(delay: Double = 0) -> some ViewModifier {
        OnAppearTransitionModifier(
            transition: .opacity,
            animation: .rythmicoSpring(duration: .durationMedium).delay(delay)
        )
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
