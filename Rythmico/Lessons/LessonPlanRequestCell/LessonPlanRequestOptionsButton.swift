import ComposableNavigator
import StudentDO
import SwiftUIEncore

struct LessonPlanRequestOptionsButton: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lessonPlanRequest: LessonPlanRequest
    let size: OptionsButton.Size
    var padding: CGFloat = 0

    var body: some View {
        if let actions = actions.nilIfEmpty {
            OptionsButton(size: size, padding: padding, actions)
        }
    }

//    @ArrayBuilder<ContextMenuButton>
    private var actions: [ContextMenuButton] {
        // TODO: upcoming
//        if let action = showCancelLessonPlanFormAction {
//            .init(title: "Withdraw Plan", icon: Asset.Icon.Action.cancel, action: action)
//        }
        []
    }

//    private var showCancelLessonPlanFormAction: Action? {
//        LessonPlanCancellationScreen(lessonPlan: lessonPlanRequest).mapToAction(go)
//    }

    private func go<S: Screen>(to screen: S) {
        navigator.go(to: screen, on: currentScreen)
    }
}
