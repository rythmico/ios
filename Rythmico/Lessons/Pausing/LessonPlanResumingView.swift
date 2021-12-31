import SwiftUIEncore
import ComposableNavigator

struct LessonPlanResumingScreen: Screen {
    let lessonPlan: LessonPlan
    let option: LessonPlan.Options.Resume
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    init?(lessonPlan: LessonPlan) {
        guard let option = lessonPlan.options.resume else { return nil }
        self.lessonPlan = lessonPlan
        self.option = option
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanResumingScreen) in
                    LessonPlanResumingView(lessonPlan: screen.lessonPlan, option: screen.option)
                }
            )
        }
    }
}

struct LessonPlanResumingView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    @StateObject
    private var coordinator = Current.lessonPlanResumingCoordinator()

    let lessonPlan: LessonPlan
    let option: LessonPlan.Options.Resume

    var body: some View {
        NavigationView {
            CoordinatorStateView(coordinator: coordinator, successTitle: "Plan Resumed", loadingTitle: "Resuming Plan...") {
                VStack(spacing: 0) {
                    TitleContentView(title) { padding in
                        ScrollView {
                            LessonPlanResumingContentView(policy: option.policy)
                                .frame(maxWidth: .grid(.max))
                                .padding(padding)
                        }
                    }

                    FloatingView {
                        RythmicoButton(submitButtonTitle, style: .secondary(), action: submit)
                    }
                }
            }
            .backgroundColor(.rythmico.backgroundSecondary)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: CloseButton(action: dismiss))
        }
        .interactiveDismissDisabled(coordinator.state.isLoading)
        .accentColor(.rythmico.foreground)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: lessonPlanSuccessfullyResumed)
        .alertOnFailure(coordinator)
    }

    private var title: String { "Confirm Resume Plan" }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }

    private var submitButtonTitle: String { "Resume Plan" }
    private func submit() {
        coordinator.run(with: .init(lessonPlanID: lessonPlan.id))
    }

    private func lessonPlanSuccessfullyResumed(_ lessonPlan: LessonPlan) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Current.lessonPlanRepository.replaceById(lessonPlan)
            // Either, depending on which tab we're on.
            navigator.goBack(to: LessonPlansScreen())
            navigator.goBack(to: LessonsScreen())
        }
    }
}

#if DEBUG
struct LessonPlanResumingView_Preview: PreviewProvider {
    static var previews: some View {
        LessonPlanResumingView(lessonPlan: .activeJackGuitarPlanStub, option: .stub)
    }
}
#endif
