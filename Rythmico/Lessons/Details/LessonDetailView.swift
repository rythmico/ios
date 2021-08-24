import SwiftUIEncore
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

    let lesson: Lesson
    let lessonPlan: LessonPlan

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            TitleContentView(title) { padding in
                VStack(alignment: .leading, spacing: .grid(5)) {
                    Pill(status: lesson.status).padding(padding)
                    ScrollView {
                        VStack(spacing: .grid(4)) {
                            LessonDetailBoxView(lesson: lesson, lessonPlan: lessonPlan)
                            LessonDetailTutorBoxView(lesson: lesson)
                        }
                        .foregroundColor(.rythmico.foreground)
                        .frame(maxWidth: .grid(.max))
                        .padding(.horizontal, .grid(4))
                    }
                }
            }

            floatingButton
        }
        .backgroundColor(.rythmico.background)
        .testable(self)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: LessonOptionsButton(lesson: lesson, size: .medium))
    }

    private var title: String { lesson.title }

    @ViewBuilder
    private var floatingButton: some View {
        FloatingActionMenu([.init(title: "View Lesson Plan", action: showLessonPlanDetailAction)])
    }

    var showLessonPlanDetailAction: Action {
        { navigator.go(to: LessonPlanDetailScreen(lessonPlan: lessonPlan), on: currentScreen) }
    }
}

#if DEBUG
struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonDetailView(lesson: .scheduledStub, lessonPlan: .activeJackGuitarPlanStub)
            LessonDetailView(lesson: .pausedStub, lessonPlan: .pausedJackGuitarPlanStub)
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
