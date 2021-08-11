import SwiftUISugar

struct IntroSlideshowFlowView<EndButton: View>: View {
    @ViewBuilder
    var endButton: () -> EndButton

    var body: some View {
        SlideshowFlowView(Step.self, content: \.content, endButton: endButton)
    }
}

extension IntroSlideshowFlowView {
    enum Step: SlideshowFlowStep {
        case one
        case two
        case three

        var asset: ImageAsset {
            switch self {
            case .one: return Asset.Graphic.Onboarding.a
            case .two: return Asset.Graphic.Onboarding.b
            case .three: return Asset.Graphic.Onboarding.c
            }
        }

        var title: String {
            switch self {
            case .one: return "1:1 Personal Tuition"
            case .two: return "Verified DBS-checked Tutors"
            case .three: return "The Complete Musician"
            }
        }

        var description: String {
            switch self {
            case .one:
                return "An exciting and creative experience where kids can explore their talents and hone their skills."
            case .two:
                return "All tutors are DBS checked with years of experience working with children, helping them dream big."
            case .three:
                return "Lessons that will support you through your music grades, but feel like band practice."
            }
        }

        @ViewBuilder
        var content: some View {
            VStack(spacing: .grid(6)) {
                Image(decorative: asset.name)
                VStack(spacing: .grid(2)) {
                    Text(title)
                        .rythmicoTextStyle(.headline)
                        .lineLimit(1)
                    Text(description)
                        .rythmicoTextStyle(.subheadline)
                        .lineLimit(3)
                }
                .minimumScaleFactor(0.5)
                .foregroundColor(.rythmico.foreground)
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, .grid(6))
        }
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
