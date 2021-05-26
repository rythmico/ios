import SwiftUI
import ComposableNavigator
import FoundationSugar

struct LessonPlanResumingScreen: Screen {
    let lessonPlan: LessonPlan
    let lessonResumingCutoff: DateComponents
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    init?(lessonPlan: LessonPlan) {
        guard lessonPlan.status.isPaused else { return nil }
        self.lessonPlan = lessonPlan
        self.lessonResumingCutoff = .init(hour: 12) // TODO: consume from LessonPlan instead
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanResumingScreen) in
                    LessonPlanResumingView(lessonPlan: screen.lessonPlan, lessonResumingCutoff: screen.lessonResumingCutoff)
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
    let lessonResumingCutoff: DateComponents

    var body: some View {
        NavigationView {
            CoordinatorStateView(coordinator: coordinator, successTitle: "Plan Resumed", loadingTitle: "Resuming Plan...") {
                VStack(spacing: 0) {
                    TitleContentView(title: title) {
                        ScrollView {
                            LessonPlanResumingContentView(lessonResumingCutoff: lessonResumingCutoff)
                                .frame(maxWidth: .spacingMax)
                                .padding(.horizontal, .spacingMedium)
                        }
                    }

                    FloatingView {
                        RythmicoButton(submitButtonTitle, style: RythmicoButtonStyle.secondary(), action: submit)
                    }
                }
            }
            .backgroundColor(.rythmicoBackgroundSecondary)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: CloseButton(action: dismiss))
        }
        .sheetInteractiveDismissal(!coordinator.state.isLoading)
        .accentColor(.rythmicoGray90)
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
        coordinator.run(with: lessonPlan.id)
    }

    private func lessonPlanSuccessfullyResumed(_ lessonPlan: LessonPlan) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Current.lessonPlanRepository.replaceById(lessonPlan)
            navigator.goBack(to: .root)
        }
    }
}

#if DEBUG
struct LessonPlanResumingView_Preview: PreviewProvider {
    static var previews: some View {
        LessonPlanResumingView(lessonPlan: .activeJackGuitarPlanStub, lessonResumingCutoff: .init(hour: 12))
    }
}
#endif
