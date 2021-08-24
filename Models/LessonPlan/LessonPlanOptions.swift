import FoundationEncore

extension LessonPlan {
    struct Options: Decodable, Hashable {
        struct Pause: Decodable, Hashable {
            struct Policy: Decodable, Hashable {
                var freeBeforeDate: Date
                @ISO8601PeriodDuration
                var freeBeforePeriod: DateComponents
            }
            var policy: Policy
        }
        struct Resume: Decodable, Hashable {
            struct Policy: Decodable, Hashable {
                @ISO8601PeriodDuration
                var allAfterPeriod: DateComponents
            }
            var policy: Policy
        }
        struct Cancel: Decodable, Hashable {
            struct Policy: Decodable, Hashable {
                var freeBeforeDate: Date
                @ISO8601PeriodDuration
                var freeBeforePeriod: DateComponents
            }
            var policy: Policy?
        }

        var pause: Pause?
        var resume: Resume?
        var cancel: Cancel?
    }
}
