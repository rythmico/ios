import SwiftUISugar

struct LessonOptionsButton: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lesson: Lesson
    let size: OptionsButton.Size
    var padding: CGFloat = 0

    var body: some View {
        if let actions = actions.nilIfEmpty {
            OptionsButton(size: size, padding: padding, actions)
                .multiModal {
                    $0.alert(isPresented: $showingRescheduleAlert) { .reschedulingView(lesson: lesson) }
                }
        }
    }

    @ArrayBuilder<ContextMenuButton>
    private var actions: [ContextMenuButton] {
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule Lesson", icon: Asset.Icon.Action.reschedule, action: action)
        }
        if let action = showSkipLessonFormAction {
            .init(title: "Skip Lesson", icon: Asset.Icon.Action.skip, action: action)
        }
    }

    @State
    private var showingRescheduleAlert = false
    private var showRescheduleAlertAction: Action? {
        lesson.status.isScheduled // TODO: consume 'Lesson.options.reschedule'.
            ? { showingRescheduleAlert = true }
            : nil
    }

    private var showSkipLessonFormAction: Action? {
        LessonSkippingScreen(lesson: lesson).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
    }
}
