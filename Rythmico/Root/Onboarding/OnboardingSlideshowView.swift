import SwiftUI

struct OnboardingSlideshowView: View {
    enum Step: CaseIterable, Hashable {
        case one, two, three

        static var maxHeight: CGFloat? {
            allCases.map(\.asset.image.size.height).max()
        }

        var asset: ImageAsset {
            switch self {
            case .one: return Asset.graphicsOnboarding1
            case .two: return Asset.graphicsOnboarding2
            case .three: return Asset.graphicsOnboarding3
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
                return "An exciting and creative experience where they can explore their talents and hone their skills."
            case .two:
                return "All tutors are DBS checked with years of experience working with children, helping them dream big."
            case .three:
                return "Lessons that will support you through your music grades, but feel like band practise."
            }
        }
    }

    @State
    private var step = Step.one

    var body: some View {
        VStack(spacing: .spacingExtraLarge) {
            PageView(
                Step.allCases,
                selection: $step,
                fixedHeight: Step.maxHeight,
                spacing: .spacingUnit * 10,
                accentColor: .rythmicoForeground,
                content: { Image(decorative: $0.asset.name) }
            )

            VStack(spacing: .spacingUnit * 2) {
                Text(step.title)
                    .rythmicoFont(.headline)
                    .foregroundColor(.rythmicoForeground)
                    .transition(.opacity)
                    .id(step.title.hashValue)
                Text(step.description)
                    .rythmicoFont(.subheadline)
                    .foregroundColor(.rythmicoGray90)
                    .transition(.opacity)
                    .id(step.description.hashValue)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, .spacingLarge)
            .animation(.easeInOut(duration: .durationShort), value: step)
        }
    }
}
