import FoundationSugar

extension LessonPlan {
    struct PauseInfo: Decodable, Hashable {
        var date: Date
    }
}
