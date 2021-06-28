import FoundationSugar

extension LessonPlan.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }

    static let stub = random()
}
