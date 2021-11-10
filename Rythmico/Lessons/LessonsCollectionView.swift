import StudentDO
import SwiftUIEncore

struct LessonsCollectionView: View {
    let isLoading: Bool
    let lessonPlanRequests: [LessonPlanRequest]
    let lessons: [Lesson]

    init(isLoading: Bool, lessonPlanRequests: [LessonPlanRequest], filter: LessonsView.Filter) {
        self.isLoading = isLoading
        switch filter {
        case .upcoming:
            self.lessonPlanRequests = lessonPlanRequests.filterOpen()
            // TODO: upcoming
            self.lessons = []// lessonPlans.allLessons().filterUpcoming()
        case .past:
            self.lessonPlanRequests = []
            // TODO: upcoming
            self.lessons = []//lessonPlans.allLessons().filterPast()
        }
    }

    var body: some View {
        LoadableCollectionView(isLoading: isLoading, topPadding: true) {
            ForEach(lessonPlanRequests) { lessonPlanRequest in
                LessonPlanRequestSummaryCell(lessonPlanRequest: lessonPlanRequest).transition(transition)
            }
            ForEach(lessons) { lesson in
                LessonSummaryCell(lesson: lesson).transition(transition)
            }
        }
    }

    private var transition: AnyTransition {
        (.scale(scale: 0.75) + .opacity).animation(.rythmicoSpring(duration: .durationMedium))
    }
}

private extension RangeReplaceableCollection where Element == LessonPlan {
    func filterRequests() -> [LessonPlan] {
        self.filter(\.isRequest)
            .sorted(by: \.schedule.startDate, <)
    }
}
