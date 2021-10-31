import SwiftUIEncore

struct LessonPlanSummaryCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lessonPlan: LessonPlan

    var body: some View {
        CustomButton(action: onTapAction) { state in
            SelectableContainer(
                fill: fill,
                radius: .large,
                borderColor: borderColor,
                isSelected: state == .pressed
            ) { state in
                VStack(alignment: .leading, spacing: 0) {
                    LessonPlanSummaryCellMainContent(lessonPlan: lessonPlan, backgroundColor: state.backgroundColor)
                    LessonPlanSummaryCellAccessory(lessonPlan: lessonPlan).hidden()
                }
                .padding(.grid(5))
            }
        }
        // Bit of a dirty hack to allow for multiple buttons in the same container,
        // Unfortunately this is the only way I've found to work so far...
        .overlay(
            LessonPlanSummaryCellAccessory(lessonPlan: lessonPlan).padding(.grid(5)),
            alignment: .bottomLeading
        )
        .overlay(
            LessonPlanOptionsButton(lessonPlan: lessonPlan, size: .small, padding: .grid(5)),
            alignment: .topTrailing
        )
    }

    var fill: ContainerStyle.Fill {
        switch lessonPlan.status {
        case .pending, .reviewing, .active:
            return .color(.rythmico.background)
        case .paused:
            return .linearGradient(
                LinearGradient(
                    gradient: Gradient(colors: [pausedColor.opacity(0.1), pausedColor.opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        case .cancelled:
            return .color(.rythmico.gray2)
        }
    }

    var borderColor: Color {
        switch lessonPlan.status {
        case .pending, .reviewing, .active, .cancelled:
            return ContainerStyle.outlineBorderColor
        case .paused:
            return pausedColor
        }
    }

    let pausedColor = Color(light: 0xD0E2FF, dark: 0x103570)

    var onTapAction: Action {
        { navigator.go(to: LessonPlanDetailScreen(lessonPlan: lessonPlan), on: currentScreen) }
    }
}

struct LessonPlanSummaryCellMainContent: View {
    let lessonPlan: LessonPlan
    let backgroundColor: Color?

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
                "Next lesson:"
                startDateString(for: nextLesson).text.rythmicoFontWeight(.bodyMedium)
            }
        case .paused:
            "Lesson plan"
            "paused".text.rythmicoFontWeight(.bodyMedium)
        case .cancelled:
            "Lesson plan"
            "cancelled".text.rythmicoFontWeight(.bodyMedium)
        }
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private func startDateString(for lesson: Lesson) -> String { Self.startDateFormatter.string(from: lesson.schedule.startDate) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: .grid(2)) {
                Text(title)
                    .rythmicoTextStyle(.subheadlineBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .opacity(opacity)
                    .frame(maxWidth: .infinity, alignment: .leading)
                OptionsButton(size: .small, []).hidden()
            }
            VSpacing(.grid(2))
            subtitle
                .rythmicoTextStyle(.body)
                .opacity(opacity)
            VSpacing(.grid(4))
            HStack(spacing: .grid(3)) {
                LessonPlanSummaryTutorStatusView(lessonPlan: lessonPlan, backgroundColor: backgroundColor).opacity(opacity)
                Pill(lessonPlan: lessonPlan)
            }
        }
        .watermark(
            lessonPlan.instrument.icon,
            color: .rythmico.picoteeBlue,
            offset: .init(width: 25, height: -20)
        )
    }

    private var opacity: Double { isDimmed ? 0.56 : 1 }
    private var isDimmed: Bool {
        switch lessonPlan.status {
        case .pending, .reviewing, .active, .paused: return false
        case .cancelled: return true
        }
    }
}

struct LessonPlanSummaryCellAccessory: View {
    typealias TitleAndAction = (title: String, action: Action)

    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var lessonPlan: LessonPlan
    var chooseTutorAction: Action? {
        LessonPlanApplicationsScreen(lessonPlan: lessonPlan).mapToAction { screen in
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
    var resumePlanAction: Action? {
        LessonPlanResumingScreen(lessonPlan: lessonPlan).mapToAction { screen in
            navigator.go(to: screen, on: currentScreen)
        }
    }
    var titleAndAction: TitleAndAction? {
        if let action = chooseTutorAction {
            return (title: "Choose tutor", action: action)
        } else if let action = resumePlanAction {
            return (title: "Resume plan", action: action)
        } else {
            return nil
        }
    }

    var body: some View {
        if let titleAndAction = titleAndAction {
            ZStack {
                RythmicoButton(
                    titleAndAction.title,
                    style: .primary(layout: .constrained(.s)),
                    action: titleAndAction.action
                )
            }
            .padding(.top, .grid(4))
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
        .backgroundColor(.rythmico.background)
//        .environment(\.colorScheme, .dark)
    }
}
#endif
