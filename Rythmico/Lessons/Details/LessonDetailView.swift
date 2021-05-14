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

                            SectionHeaderView(title: "Tutor")
                            TutorCell(tutor: lesson.tutor)
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
        .navigationBarItems(trailing: moreButton)
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) }
        }
    }

    private var title: String { lesson.title }

    @ViewBuilder
    private var moreButton: some View {
        if let actions = actions.nilIfEmpty {
            MoreButton(actions)
        }
    }

    @ArrayBuilder<MoreButton.Button>
    private var actions: [MoreButton.Button] {
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule Lesson", action: action)
        }
        if let action = showSkipLessonFormAction {
            .init(title: "Skip Lesson", action: action)
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
