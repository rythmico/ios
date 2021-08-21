import SwiftUISugar
import ComposableNavigator

struct LessonPlanOptionsButton: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lessonPlan: LessonPlan
    let size: OptionsButton.Size
    var padding: CGFloat = 0

    var body: some View {
        if let actions = actions.nilIfEmpty {
            OptionsButton(size: size, padding: padding, actions)
                .multiModal {
                    $0.alert(isPresented: $showingRescheduleAlert) { .reschedulingView(lessonPlan: lessonPlan) }
                }
        }
    }

    @ArrayBuilder<ContextMenuButton>
    private var actions: [ContextMenuButton] {
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule Plan", icon: Asset.Icon.Action.reschedule, action: action)
        }
        if let action = showPauseLessonPlanFormAction {
            .init(title: "Pause Plan", icon: Asset.Icon.Action.pause, action: action)
        }
        if let action = showResumeLessonPlanFormAction {
            .init(title: "Resume Plan", icon: Asset.Icon.Action.resume, action: action)
        }
        if let action = showCancelLessonPlanFormAction {
            .init(title: "Cancel Plan", icon: Asset.Icon.Action.cancel, action: action)
        }
    }

    @State
    private var showingRescheduleAlert = false
    private var showRescheduleAlertAction: Action? {
        !lessonPlan.status.isCancelled && !lessonPlan.status.isPaused // TODO: consume 'LessonPlan.options.reschedule'.
            ? { showingRescheduleAlert = true }
            : nil
    }

    private var showPauseLessonPlanFormAction: Action? {
        LessonPlanPausingScreen(lessonPlan: lessonPlan).mapToAction(go)
    }

    private var showResumeLessonPlanFormAction: Action? {
        LessonPlanResumingScreen(lessonPlan: lessonPlan).mapToAction(go)
    }

    private var showCancelLessonPlanFormAction: Action? {
        LessonPlanCancellationScreen(lessonPlan: lessonPlan).mapToAction(go)
    }

    private func go<S: Screen>(to screen: S) {
        navigator.go(to: screen, on: currentScreen)
    }
}
