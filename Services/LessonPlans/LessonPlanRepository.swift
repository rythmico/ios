import Foundation
import Combine

final class LessonPlanRepository: ObservableObject {
    @Published var lessonPlans: [LessonPlan] = []
}
