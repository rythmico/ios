import SwiftUI

struct LessonPlanSummaryCell: View {
    var lessonPlan: LessonPlan
    var transitionDelay: Double?

    var title: String {
        [
            lessonPlan.student.name.firstWord,
            "\(lessonPlan.instrument.name) Lessons"
        ].compactMap { $0 }.joined(separator: " - ")
    }

    var subtitle: String {
        switch lessonPlan.status {
        case .pending:
            return "Pending tutor applications"
        default:
            return "" // TODO
        }
    }

    var tutorImage: AnyView {
        switch lessonPlan.status {
        case .pending:
            return AnyView(Image(systemSymbol: .person).foregroundColor(.rythmicoGray90).font(.system(size: 18, weight: .medium, design: .rounded)))
        default:
            return AnyView(Image(systemSymbol: .personFill)) // TODO
        }
    }

    var tutor: String {
        switch lessonPlan.status {
        case .pending:
            return "Tutor TBC"
        default:
            return "" // TODO
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                Text(title)
                    .rythmicoFont(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
                Text(subtitle)
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray90)
                HStack(spacing: .spacingExtraSmall) {
                    tutorImage
                        .frame(width: 32, height: 32)
                        .background(Color.rythmicoGray10.clipShape(Circle()))
                    Text(tutor)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .rythmicoFont(.body)
                        .foregroundColor(.rythmicoGray90)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    LessonPlanStatusPill(lessonPlan.status)
                }
            }
        }
        .padding(.spacingMedium)
        .modifier(RoundedShadowContainer())
        .transition(
            AnyTransition
                .opacity
                .combined(with: .scale(scale: 0.8))
                .animation(
                    Animation
                        .rythmicoSpring(duration: .durationMedium)
                        .delay(transitionDelay ?? 0)
                )
        )
    }
}
