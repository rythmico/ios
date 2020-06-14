import Foundation
import Combine

final class LessonPlanRepository: ObservableObject {
    @Published var lessonPlans: [LessonPlan] = [] {
        willSet {
            previousLessonPlans = lessonPlans
        }
    }

    private(set) var previousLessonPlans: [LessonPlan] = []
}
