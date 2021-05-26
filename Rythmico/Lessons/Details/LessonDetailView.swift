import SwiftUI
import ComposableNavigator
import MultiModal
import FoundationSugar

struct LessonDetailScreen: Screen {
    let lesson: Lesson
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonDetailScreen) in
                    LessonDetailView(lesson: screen.lesson)
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
    var lessonPlan: LessonPlan? { Current.lessonPlanRepository.firstById(lesson.lessonPlanId) }

    var lessonReschedulingView: LessonReschedulingView? { lessonPlan?.status.isCancelled == false ? .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) : nil }

    var showLessonPlanDetailAction: Action? {
        lessonPlan.map(LessonPlanDetailScreen.init).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
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
            TitleContentView(title: title) {
                VStack(alignment: .leading, spacing: .spacingExtraLarge) {
                    Pill(status: lesson.status)
                        .padding(.horizontal, .spacingMedium)

                    ScrollView {
                        VStack(alignment: .leading, spacing: .spacingMedium) {
                            SectionHeaderView(title: "Lesson Details")
                            LessonScheduleView(lesson: lesson)
                            AddressLabel(address: lesson.address)

                            tutorSection
                        }
                        .foregroundColor(.rythmicoGray90)
                        .frame(maxWidth: .spacingMax)
                        .padding(.horizontal, .spacingMedium)
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
    private var tutorSection: some View {
        if let lessonPlan = lessonPlan {
            SectionHeaderView(title: "Tutor")
            TutorCell(lessonPlan: lessonPlan, tutor: lesson.tutor)
        }
    }

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
        if let action = showLessonPlanDetailAction {
            FloatingActionMenu([.init(title: "View Lesson Plan", action: action)])
        }
    }
}

#if DEBUG
struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: .scheduledStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
