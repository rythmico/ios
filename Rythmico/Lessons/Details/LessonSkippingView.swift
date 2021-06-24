import SwiftUISugar
import ComposableNavigator

struct LessonSkippingScreen: Screen {
    let lesson: Lesson
    let option: Lesson.Options.Skip
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    init?(lesson: Lesson) {
        guard let option = lesson.options.skip else { return nil }
        self.lesson = lesson
        self.option = option
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonSkippingScreen) in
                    LessonSkippingView(lesson: screen.lesson, option: screen.option)
                }
            )
        }
    }
}

struct LessonSkippingView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    @StateObject
    private var coordinator = Current.lessonSkippingCoordinator()

    let lesson: Lesson
    let option: Lesson.Options.Skip

    @State private
    var showingConfirmationSheet = false

    var body: some View {
        NavigationView {
            CoordinatorStateView(coordinator: coordinator, successTitle: "Lesson Skipped", loadingTitle: "Skipping Lesson...") {
                VStack(spacing: 0) {
                    TitleContentView(title: title) {
                        ScrollView {
                            LessonSkippingContentView(isFree: isFree, policy: option.policy)
                                .frame(maxWidth: .grid(.max))
                                .padding(.horizontal, .grid(5))
                        }
                    }

                    FloatingView {
                        RythmicoButton(submitButtonTitle, style: RythmicoButtonStyle.secondary(), action: onSkipButtonPressed)
                            .actionSheet(isPresented: $showingConfirmationSheet) {
                                ActionSheet(
                                    title: Text("Are you sure?"),
                                    message: Text("You will still be charged the full amount for this lesson."),
                                    buttons: [.destructive(Text("Skip Lesson"), action: submit), .cancel()]
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
        .onSuccess(coordinator, perform: lessonSuccessfullySkipped)
        .alertOnFailure(coordinator)
    }

    private var title: String { "Confirm Skip Lesson" }

    private var isFree: Bool {
        Current.date() < option.policy.freeBeforeDate
    }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }

    private func submit() {
        coordinator.run(with: lesson)
    }

    private var submitButtonTitle: String {
        isFree ? "Skip Lesson For Free" : "Skip Lesson"
    }

    private func onSkipButtonPressed() {
        if isFree {
            submit()
        } else {
            showingConfirmationSheet = true
        }
    }

    private func lessonSuccessfullySkipped(_ lessonPlan: LessonPlan) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Current.lessonPlanRepository.replaceById(lessonPlan)
            navigator.goBack(to: .root)
        }
    }
}

#if DEBUG
struct LessonSkippingView_Preview: PreviewProvider {
    static var previews: some View {
        LessonSkippingView(lesson: .scheduledStub, option: .stub)
    }
}
#endif
