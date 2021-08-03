import SwiftUISugar
import ComposableNavigator

struct LessonDetailScreen: Screen {
    let lesson: Lesson
    let lessonPlan: LessonPlan
    let presentationStyle: ScreenPresentationStyle = .push

    init?(lesson: Lesson) {
        guard let lessonPlan = Current.lessonPlanRepository.firstById(lesson.lessonPlanId) else { return nil }
        self.lesson = lesson
        self.lessonPlan = lessonPlan
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonDetailScreen) in
                    LessonDetailView(lesson: screen.lesson, lessonPlan: screen.lessonPlan)
                },
                nesting: {
                    LessonSkippingScreen.Builder()
                    LessonPlanTutorDetailScreen.Builder()
                    LessonPlanDetailScreen.Builder()
                }
            )
        }
    }
}

struct LessonDetailView: View, TestableView {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var lesson: Lesson
    var lessonPlan: LessonPlan

    var lessonReschedulingView: LessonReschedulingView? { !lessonPlan.status.isCancelled && !lessonPlan.status.isPaused ? .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) : nil }

    var showLessonPlanDetailAction: Action {
        { navigator.go(to: LessonPlanDetailScreen(lessonPlan: lessonPlan), on: currentScreen) }
    }

    @State
    private var isRescheduling = false // TODO: move to AppNavigation
    var showRescheduleAlertAction: Action? {
        lessonReschedulingView != nil
            ? { isRescheduling = true }
            : nil
    }

    var showSkipLessonFormAction: Action? {
        LessonSkippingScreen(lesson: lesson).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            TitleContentView(title) { padding in
                VStack(alignment: .leading, spacing: .grid(5)) {
                    Pill(status: lesson.status).padding(padding)
                    ScrollView {
                        VStack(spacing: .grid(4)) {
                            SectionHeaderContentView("Lesson Details", style: .box) {
                                VStack(alignment: .leading, spacing: .grid(2)) {
                                    LessonScheduleView(lesson: lesson)
                                    AddressLabel(address: lesson.address)
                                }
                            }
                            SectionHeaderContentView("Tutor", style: .box) {
                                LessonDetailTutorStatusView(lesson: lesson)
                            }
                        }
                        .foregroundColor(.rythmico.foreground)
                        .frame(maxWidth: .grid(.max))
                        .padding(.horizontal, .grid(4))
                    }
                }
            }

            floatingButton
        }
        .testable(self)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: optionsButton)
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) }
        }
    }

    private var title: String { lesson.title }

    @ViewBuilder
    private var optionsButton: some View {
        if let actions = actions.nilIfEmpty {
            OptionsButton(actions)
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

    @ViewBuilder
    private var floatingButton: some View {
        FloatingActionMenu([.init(title: "View Lesson Plan", action: showLessonPlanDetailAction)])
    }
}

#if DEBUG
struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: .scheduledStub, lessonPlan: .activeJackGuitarPlanStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
