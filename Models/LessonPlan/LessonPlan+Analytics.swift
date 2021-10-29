import FoundationEncore
import StudentDTO

extension AnalyticsEvent {
    @PropsBuilder
    static func lessonPlanProps(_ lessonPlan: LessonPlan) -> Props {
        ["Lesson Plan ID": lessonPlan.id.rawValue]
        lessonPlanProps(
            lessonPlan.instrument,
            lessonPlan.student,
            lessonPlan.address,
            lessonPlan.schedule
        )
    }

    @PropsBuilder
    static func lessonPlanProps(
        _ instrument: Instrument?,
        _ student: Student?,
        _ address: AddressProtocol?,
        _ schedule: Schedule?
    ) -> Props {
        if let instrument = instrument {
            ["Instrument": instrument.rawValue]
        }
        if let student = student {
            ["Student Age": try! Current.dateOnly() - (student.dateOfBirth, .year)]
        }
        if let postcodeDistrict = address?.postcode.firstWord {
            ["Address District": postcodeDistrict]
        }
        if let schedule = schedule {
            if let dayOfWeek = dayOfWeek(for: schedule.startDate) {
                ["Lesson Day": dayOfWeek]
            }
            if let time = time(for: schedule.startDate) {
                ["Lesson Time": time]
            }
            ["Lesson Duration": schedule.duration.rawValue]
        }
    }

    private enum DayOfWeek: String, CaseIterable {
        case sunday = "SUNDAY"
        case monday = "MONDAY"
        case tuesday = "TUESDAY"
        case wednesday = "WEDNESDAY"
        case thursday = "THURSDAY"
        case friday = "FRIDAY"
        case saturday = "SATURDAY"
    }

    private static func dayOfWeek(for date: Date) -> String? {
        let calendar = Calendar(identifier: .gregorian) => (\.timeZone, Current.timeZone())
        let weekday = calendar.component(.weekday, from: date)
        let index = weekday - 1
        return DayOfWeek.allCases[safe: index]?.rawValue
    }

    private static func time(for date: Date) -> String? {
        (DateFormatter() => {
            $0.locale = .neutral
            $0.timeZone = Current.timeZone()
            $0.dateFormat = "HH:mm"
        })
        .string(from: date)
    }
}
