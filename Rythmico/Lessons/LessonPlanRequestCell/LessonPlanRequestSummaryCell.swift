import StudentDO
import SwiftUIEncore

struct LessonPlanRequestSummaryCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lessonPlanRequest: LessonPlanRequest

    var body: some View {
        CustomButton(action: onTapAction) { state in
            SelectableContainer(
                fill: fill,
                radius: .large,
                borderColor: borderColor,
                isSelected: state == .pressed
            ) { state in
                VStack(alignment: .leading, spacing: 0) {
                    LessonPlanRequestSummaryCellMainContent(lessonPlanRequest: lessonPlanRequest, backgroundColor: state.backgroundColor)
                    LessonPlanRequestSummaryCellAccessory(lessonPlanRequest: lessonPlanRequest).hidden()
                }
                .padding(.grid(5))
            }
        }
        // Bit of a dirty hack to allow for multiple buttons in the same container,
        // Unfortunately this is the only way I've found to work so far...
        .overlay(
            LessonPlanRequestSummaryCellAccessory(lessonPlanRequest: lessonPlanRequest).padding(.grid(5)),
            alignment: .bottomLeading
        )
        .overlay(
            LessonPlanRequestOptionsButton(lessonPlanRequest: lessonPlanRequest, size: .small, padding: .grid(5)),
            alignment: .topTrailing
        )
    }

    var fill: ContainerStyle.Fill {
        switch lessonPlanRequest.status {
        case .pending:
            return .color(.rythmico.background)
        }
    }

    var borderColor: Color {
        switch lessonPlanRequest.status {
        case .pending:
            return ContainerStyle.outlineBorderColor
        }
    }

    let pausedColor = Color(light: 0xD0E2FF, dark: 0x103570)

    var onTapAction: Action {
        // TODO: upcoming
        // { navigator.go(to: LessonPlanDetailScreen(lessonPlan: lessonPlanRequest), on: currentScreen) }
        {}
    }
}

struct LessonPlanRequestSummaryCellMainContent: View {
    let lessonPlanRequest: LessonPlanRequest
    let backgroundColor: Color?

    var title: String {
        [
            lessonPlanRequest.student.name.firstWord,
            "\(lessonPlanRequest.instrument.assimilatedName) Lessons"
        ].compacted().joined(separator: " - ")
    }

    @SpacedTextBuilder
    var subtitle: Text {
        switch lessonPlanRequest.status {
        case .pending:
            "Pending tutor applications"
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
                LessonPlanRequestSummaryTutorStatusView(lessonPlanRequest: lessonPlanRequest, backgroundColor: backgroundColor).opacity(opacity)
                Pill(lessonPlanRequest: lessonPlanRequest)
            }
        }
        .watermark(
            lessonPlanRequest.instrument.icon,
            color: .rythmico.picoteeBlue,
            offset: .init(width: 25, height: -20)
        )
    }

    private var opacity: Double { isDimmed ? 0.56 : 1 }
    private var isDimmed: Bool {
        switch lessonPlanRequest.status {
        case .pending: return false
        }
    }
}

struct LessonPlanRequestSummaryCellAccessory: View {
    typealias TitleAndAction = (title: String, action: Action)

    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var lessonPlanRequest: LessonPlanRequest
    // TODO: upcoming
//    var chooseTutorAction: Action? {
//        LessonPlanApplicationsScreen(lessonPlan: lessonPlan).mapToAction { screen in
//            navigator.go(to: screen, on: currentScreen)
//            Current.analytics.track(
//                .chooseTutorScreenView(
//                    lessonPlan: screen.lessonPlan,
//                    applications: screen.applications,
//                    origin: .lessonsTabCell
//                )
//            )
//        }
//    }
    var titleAndAction: TitleAndAction? {
        // TODO: upcoming
//        if let action = chooseTutorAction {
//            return (title: "Choose tutor", action: action)
//        } else {
            return nil
//        }
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
struct LessonPlanRequestSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanRequestSummaryCell(lessonPlanRequest: .stub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .backgroundColor(.rythmico.background)
//        .environment(\.colorScheme, .dark)
    }
}
#endif
