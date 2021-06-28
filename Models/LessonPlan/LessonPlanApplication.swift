import FoundationSugar

extension LessonPlan {
    typealias Applications = NonEmptyArray<Application>

    struct Application: Decodable, Hashable {
        var tutor: Tutor
        var privateNote: String
    }
}
