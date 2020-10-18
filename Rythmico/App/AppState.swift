import Combine
import Then

final class AppState: ObservableObject {
    @Published var tab = MainView.Tab.lessons
    @Published var isRequestingLessonPlan = false

    @Published var selectedLessonPlan: LessonPlan?
    @Published var isCancellingLessonPlan = false

    @Published var reviewingLessonPlan: LessonPlan?
    @Published var reviewingLessonPlanApplication: LessonPlan.Application?
    @Published var isBookingLessonPlan = false
}

extension AppState: Then {}
