import SwiftUIEncore
import ComposableNavigator

struct LessonDetailBoxView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lesson: Lesson
    let lessonPlan: LessonPlan

    var body: some View {
        SectionHeaderContentView(title, style: .box, accessory: accessory) {
            VStack(alignment: .leading, spacing: .grid(2)) {
                LessonScheduleView(lesson: lesson)
                AddressLabel(address: lesson.address)
            }
            .opacity(opacity)
        }
    }

    private var title: String {
        switch lesson.status {
        case .scheduled, .completed:
            return "Lesson Details"
        case .skipped:
            return "Lesson has been skipped"
        case .paused:
            return "Lesson plan is paused"
        case .cancelled:
            return "Lesson plan was cancelled"
        }
    }

    @ViewBuilder
    private func accessory() -> some View {
        switch lesson.status {
        case .scheduled, .completed, .skipped, .cancelled:
            EmptyView()
        case .paused:
            if let action = resumeAction {
                RythmicoButton("RESUME", style: .tertiary(layout: .constrained(.xs)), action: action)
            }
        }
    }

    private var resumeAction: Action? {
        LessonPlanResumingScreen(lessonPlan: lessonPlan).mapToAction { resumeScreen in
            navigator.go(
                to: [
                    AnyScreen(LessonPlanDetailScreen(lessonPlan: lessonPlan)),
                    AnyScreen(resumeScreen)
                ],
                on: currentScreen
            )
        }
    }

    private var opacity: Double {
        switch lesson.status {
        case .scheduled, .completed:
            return 1
        case .skipped, .paused, .cancelled:
            return 0.3
        }
    }
}
