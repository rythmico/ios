import SwiftUI
import ComposableNavigator
import FoundationSugar

struct LessonSkippingScreen: Screen {
    let lesson: Lesson
    let freeSkipUntil: Date
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    init?(lesson: Lesson) {
        guard let freeSkipUntil = lesson.freeSkipUntil else { return nil }
        self.lesson = lesson
        self.freeSkipUntil = freeSkipUntil
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonSkippingScreen) in
                    LessonSkippingView(lesson: screen.lesson, freeSkipUntil: screen.freeSkipUntil)
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
    let freeSkipUntil: Date

    @State private
    var showingConfirmationSheet = false

    var body: some View {
        NavigationView {
            CoordinatorStateView(coordinator: coordinator, successTitle: "Lesson Skipped", loadingTitle: "Skipping Lesson...") {
                VStack(spacing: 0) {
                    TitleContentView(title: "Confirm Skip Lesson") {
                        ScrollView {
                            LessonSkippingContentView(
                                isFree: isFree,
                                freeSkipUntil: freeSkipUntil
                            )
                            .frame(maxWidth: .spacingMax)
                            .padding(.horizontal, .spacingMedium)
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

    private var isFree: Bool {
        Current.date() < freeSkipUntil
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
        LessonSkippingView(lesson: .scheduledStub, freeSkipUntil: Lesson.scheduledStub.freeSkipUntil!)
    }
}
#endif
