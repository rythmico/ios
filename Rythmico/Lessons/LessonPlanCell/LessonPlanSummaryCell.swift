import SwiftUISugar

struct LessonPlanSummaryCell: View {
    var lessonPlan: LessonPlan

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LessonPlanSummaryCellMainContent(lessonPlan: lessonPlan)
            LessonPlanSummaryCellAccessory(lessonPlan: lessonPlan)
        }
        .modifier(RoundedShadowContainer())
    }
}

struct LessonPlanSummaryCellMainContent: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen
    @Environment(\.colorScheme) private var colorScheme

    var lessonPlan: LessonPlan

    var title: String {
        [
            lessonPlan.student.name.firstWord,
            "\(lessonPlan.instrument.assimilatedName) Lessons"
        ].compacted().joined(separator: " - ")
    }

    @SpacedTextBuilder
    var subtitle: Text {
        switch lessonPlan.status {
        case .pending:
            "Pending tutor applications"
        case .reviewing:
            "Pending selection of tutor"
        case .active(let props):
            if let nextLesson = props.lessons.nextLesson() {
                "Next Lesson:"
                startDateString(for: nextLesson).text.rythmicoFontWeight(.bodyMedium)
            }
        case .paused:
            "Plan Paused"
        case .cancelled:
            "Plan Cancelled"
        }
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private func startDateString(for lesson: Lesson) -> String { Self.startDateFormatter.string(from: lesson.schedule.startDate) }

    var body: some View {
        Button(action: { navigator.go(to: LessonPlanDetailScreen(lessonPlan: lessonPlan), on: currentScreen) }) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .rythmicoTextStyle(.subheadlineBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundColor(.rythmico.foreground)
                    .opacity(opacity)
                VSpacing(.grid(2))
                subtitle
                    .rythmicoTextStyle(.body)
                    .foregroundColor(.rythmico.gray90)
                    .opacity(opacity)
                VSpacing(.grid(3))
                HStack(spacing: .grid(3)) {
                    LessonPlanTutorStatusView(lessonPlan: lessonPlan, summarized: true).opacity(opacity)
                    Pill(lessonPlan: lessonPlan, backgroundColor: .rythmico.backgroundTertiary)
                }
            }
            .padding(.grid(5))
        }
        .watermark(
            lessonPlan.instrument.icon.image,
            offset: .init(width: 50, height: -20),
            opacity: colorScheme == .dark ? 0.04 : nil
        )
    }

    private var opacity: Double { isDimmed ? 0.5 : 1 }
    private var isDimmed: Bool {
        switch lessonPlan.status {
        case .pending, .reviewing, .active: return false
        case .paused, .cancelled: return true
        }
    }
}

struct LessonPlanSummaryCellAccessory: View {
    typealias TitleAndAction = (title: String, action: Action)

    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var lessonPlan: LessonPlan
    var chooseTutorAction: Action? {
        LessonPlanApplicationsScreen(lessonPlan: lessonPlan).map { screen in
            {
                navigator.go(to: screen, on: currentScreen)
                Current.analytics.track(
                    .chooseTutorScreenView(
                        lessonPlan: screen.lessonPlan,
                        applications: screen.applications,
                        origin: .lessonsTabCell
                    )
                )
            }
        }
    }
    var resumePlanAction: Action? {
        LessonPlanResumingScreen(lessonPlan: lessonPlan).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
    }
    var titleAndAction: TitleAndAction? {
        if let action = chooseTutorAction {
            return (title: "Choose Tutor", action: action)
        } else if let action = resumePlanAction {
            return (title: "Resume Plan", action: action)
        } else {
            return nil
        }
    }

    var body: some View {
        if let titleAndAction = titleAndAction {
            Divider().overlay(Color.rythmico.gray20)

            Button(action: titleAndAction.action) {
                HStack(spacing: .grid(3)) {
                    Text(titleAndAction.title)
                        .rythmicoTextStyle(.bodySemibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemSymbol: .chevronRight)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
                .padding(.grid(5))
                .foregroundColor(.rythmico.purple)
            }
            .background(Color.rythmico.purple.opacity(0.02))
        }
    }
}

#if DEBUG
struct LessonPlanSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanSummaryCell(lessonPlan: .pendingJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .reviewingJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .activeJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .pausedJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .cancelledJackGuitarPlanStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
