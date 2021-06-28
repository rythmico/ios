import FoundationSugar

extension LessonPlan {
    enum Status: Decodable, Hashable {
        case pending
        case reviewing(ReviewingProps)
        case active(ActiveProps)
        case paused(PausedProps)
        case cancelled(CancelledProps)

        struct ReviewingProps: Decodable, Hashable {
            var applications: Applications
        }

        struct ActiveProps: Decodable, Hashable {
            var lessons: [Lesson]
            var bookingInfo: BookingInfo
        }

        struct PausedProps: Decodable, Hashable {
            var lessons: [Lesson]
            var bookingInfo: BookingInfo
            var pauseInfo: PauseInfo
        }

        struct CancelledProps: Decodable, Hashable {
            var lessons: [Lesson]?
            var bookingInfo: BookingInfo?
            var cancellationInfo: CancellationInfo
        }

        init(from decoder: Decoder) throws {
            self = (try? CancelledProps(from: decoder)).map(Self.cancelled)
                ?? (try? PausedProps(from: decoder)).map(Self.paused)
                ?? (try? ActiveProps(from: decoder)).map(Self.active)
                ?? (try? ReviewingProps(from: decoder)).map(Self.reviewing)
                ?? .pending
        }
    }
}

extension LessonPlan.Status {
    var isPending: Bool {
        guard case .pending = self else { return false }
        return true
    }

    var isReviewing: Bool {
        guard case .reviewing = self else { return false }
        return true
    }

    var isActive: Bool {
        guard case .active = self else { return false }
        return true
    }

    var isPaused: Bool {
        guard case .paused = self else { return false }
        return true
    }

    var isCancelled: Bool {
        guard case .cancelled = self else { return false }
        return true
    }
}
