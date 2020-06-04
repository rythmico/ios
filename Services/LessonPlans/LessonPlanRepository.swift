import Foundation
import Combine

final class LessonPlanRepository: ObservableObject {
    static let shared = LessonPlanRepository()
    @Published var lessonPlans: [LessonPlan] = []
}
