import FoundationEncore

extension LessonPlan {
    struct CancellationInfo: Decodable, Hashable {
        enum Reason: String, Codable, Hashable {
            case noApplicants = "NO_APPLICANTS"
            case badApplicants = "BAD_APPLICANTS"
            case tooExpensive = "TOO_EXPENSIVE"
            case badTutor = "BAD_TUTOR"
            case rearrangementNeeded = "NEED_REARRANGEMENT"
            case other = "OTHER"
        }

        var date: Date
        var reason: Reason
    }
}
