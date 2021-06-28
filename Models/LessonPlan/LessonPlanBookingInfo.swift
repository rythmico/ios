import FoundationSugar

extension LessonPlan {
    struct BookingInfo: Decodable, Hashable {
        var date: Date
        var tutor: Tutor
    }
}
