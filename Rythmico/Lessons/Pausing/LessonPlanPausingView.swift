import SwiftUI
import ComposableNavigator
import FoundationSugar

struct LessonPlanPausingScreen: Screen {
    let lessonPlan: LessonPlan
    let option: LessonPlan.Options.Pause
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    init?(lessonPlan: LessonPlan) {
        guard let option = lessonPlan.options.pause else { return nil }
        self.lessonPlan = lessonPlan
        self.option = option
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanPausingScreen) in
                    LessonPlanPausingView(lessonPlan: screen.lessonPlan, option: screen.option)
                }
            )
        }
    }
}

struct LessonPlanPausingView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    @StateObject
    private var coordinator = Current.lessonPlanPausingCoordinator()

    let lessonPlan: LessonPlan
    let option: LessonPlan.Options.Pause

    @State private
    var showingConfirmationSheet = false

    var body: some View {
        NavigationView {
            CoordinatorStateView(coordinator: coordinator, successTitle: "Plan Paused", loadingTitle: "Pausing Plan...") {
                VStack(spacing: 0) {
                    TitleContentView(title: title) {
                        ScrollView {
                            LessonPlanPausingContentView(isFree: isFree, policy: option.policy)
                                .frame(maxWidth: .spacingMax)
                                .padding(.horizontal, .spacingMedium)
                        }
                    }

                    FloatingView {
                        RythmicoButton(submitButtonTitle, style: RythmicoButtonStyle.secondary(), action: onPauseButtonPressed)
                            .actionSheet(isPresented: $showingConfirmationSheet) {
                                ActionSheet(
                                    title: Text("Are you sure?"),
                                    message: Text("You will still be charged the full amount for your upcoming lesson."),
                                    buttons: [.destructive(Text("Pause Plan"), action: submit), .cancel()]
                                )
                            }
                            .disabled(showingConfirmationSheet)
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
        .onSuccess(coordinator, perform: lessonPlanSuccessfullyPaused)
        .alertOnFailure(coordinator)
    }

    private var title: String { "Confirm Pause Plan" }

    private var isFree: Bool {
        Current.date() < option.policy.freeBefore
    }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }

    private func submit() {
        coordinator.run(with: lessonPlan.id)
    }

    private var submitButtonTitle: String {
        isFree ? "Pause Plan For Free" : "Pause Plan"
    }

    private func onPauseButtonPressed() {
        if isFree {
            submit()
        } else {
            showingConfirmationSheet = true
        }
    }

    private func lessonPlanSuccessfullyPaused(_ lessonPlan: LessonPlan) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Current.lessonPlanRepository.replaceById(lessonPlan)
            navigator.goBack(to: .root)
        }
    }
}

#if DEBUG
struct LessonPlanPausingView_Preview: PreviewProvider {
    static var previews: some View {
        LessonPlanPausingView(lessonPlan: .activeJackGuitarPlanStub, option: .stub)
    }
}
#endif
