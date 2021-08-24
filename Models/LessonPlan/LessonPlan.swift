import FoundationEncore

struct LessonPlan: Identifiable, Hashable {
    var id: ID
    var status: Status
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String
    var options: Options
}

extension LessonPlan: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            id: container.decode(ID.self, forKey: .id),
            status: Status(from: decoder),
            instrument: container.decode(Instrument.self, forKey: .instrument),
            student: container.decode(Student.self, forKey: .student),
            address: container.decode(Address.self, forKey: .address),
            schedule: container.decode(Schedule.self, forKey: .schedule),
            privateNote: container.decode(String.self, forKey: .privateNote),
            options: container.decode(Options.self, forKey: .options)
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case instrument
        case student
        case address
        case schedule
        case privateNote
        case options
    }
}

extension LessonPlan {
    var applications: Applications? {
        switch status {
        case .pending: return nil
        case .reviewing(let p): return p.applications
        case .active: return nil
        case .paused: return nil
        case .cancelled: return nil
        }
    }

    var bookingInfo: BookingInfo? {
        switch status {
        case .pending: return nil
        case .reviewing: return nil
        case .active(let p): return p.bookingInfo
        case .paused(let p): return p.bookingInfo
        case .cancelled(let p): return p.bookingInfo
        }
    }

    var lessons: [Lesson]? {
        switch status {
        case .pending: return nil
        case .reviewing: return nil
        case .active(let p): return p.lessons
        case .paused(let p): return p.lessons
        case .cancelled(let p): return p.lessons
        }
    }

    var isRequest: Bool {
        switch status {
        case .pending, .reviewing:
            return true
        case .active, .paused, .cancelled:
            return false
        }
    }
}

extension RangeReplaceableCollection where Element == LessonPlan {
    func allLessons() -> [Lesson] {
        self.compactMap(\.lessons)
            .flattened()
    }
}
