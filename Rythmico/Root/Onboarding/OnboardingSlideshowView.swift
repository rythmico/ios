import SwiftUI

struct OnboardingSlideshowView: View {
    enum Step: Int, CaseIterable, Hashable {
        case one, two, three

        static var maxHeight: CGFloat? {
            allCases.map(\.asset.image.size.height).max()
        }

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

        var next: Step {
            Self(rawValue: rawValue + 1) ?? self
        }

        var previous: Step {
            Self(rawValue: rawValue - 1) ?? self
        }
    }

    @State
    private var step = Step.one

    var body: some View {
        VStack(spacing: secondSpacing) {
            PageView(
                data: Step.allCases,
                selection: $step,
                fixedHeight: fixedImageHeight,
                spacing: firstSpacing,
                accentColor: .rythmicoForeground
            ) {
                Image(decorative: $0.asset.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, .spacingMedium)
            }

            VStack(spacing: .spacingUnit * 2) {
                Text(step.title)
                    .rythmicoTextStyle(.headline)
                    .foregroundColor(.rythmicoForeground)
                    .transition(.opacity)
                    .id(step.title.hashValue)
                Text(step.description)
                    .rythmicoTextStyle(.subheadline)
                    .foregroundColor(.rythmicoGray90)
                    .transition(.opacity)
                    .id(step.description.hashValue)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingLarge)
        }
        .animation(.easeInOut(duration: .durationShort), value: step)
        .gesture(
            DragGesture(minimumDistance: 60).onEnded {
                guard abs($0.translation.width) >= 60 else { return }
                step = $0.translation.width > 0 ? step.previous : step.next
            }
        )
    }

    private var isCompact: Bool {
        UIScreen.main.bounds.height <= 568 // iPhone 5/SE size.
    }

    private var fixedImageHeight: CGFloat? {
        isCompact ? Step.maxHeight.map { $0 * 0.8 } : Step.maxHeight
    }

    private var firstSpacing: CGFloat {
        isCompact ? .spacingMedium : .spacingUnit * 10
    }

    private var secondSpacing: CGFloat {
        isCompact ? .spacingSmall : .spacingExtraLarge
    }
}
