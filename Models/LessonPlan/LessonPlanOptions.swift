import FoundationEncore

extension LessonPlan {
    struct Options: Decodable, Hashable {
        struct Pause: Decodable, Hashable {
            struct Policy: Decodable, Hashable {
                var freeBeforeDate: Date
                var freeBeforePeriod: PeriodDuration
            }
            var policy: Policy
        }
        struct Resume: Decodable, Hashable {
            struct Policy: Decodable, Hashable {
                var allAfterPeriod: PeriodDuration
            }
            var policy: Policy
        }
        struct Cancel: Decodable, Hashable {
            struct Policy: Decodable, Hashable {
                var freeBeforeDate: Date
                var freeBeforePeriod: PeriodDuration
            }
            var policy: Policy?
        }

        var pause: Pause?
        var resume: Resume?
        var cancel: Cancel?
    }
}
