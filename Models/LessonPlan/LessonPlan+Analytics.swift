import Foundation
import FoundationSugar

extension AnalyticsEvent {
    static func lessonPlanProps(_ lessonPlan: LessonPlan) -> Props {
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
        _ address: Address?,
        _ schedule: Schedule?
    ) -> Props {
        if let instrument = instrument {
            ["Instrument": instrument.rawValue]
        }
        if let student = student {
            ["Student Age": Current.date() - (student.dateOfBirth, .year)]
        }
        if let postcodeDistrict = address?.postcode.firstWord {
            ["Address District": postcodeDistrict]
        }
        if let schedule = schedule {
            if let weekday = unlocalizedWeekday(for: schedule.startDate) {
                ["Lesson Day": weekday]
            }
            if let time = time(for: schedule.startDate) {
                ["Lesson Time": time]
            }
            ["Lesson Duration": schedule.duration.rawValue]
        }
    }

    private enum UnlocalizedWeekday: String, CaseIterable {
        case sunday = "SUNDAY"
        case monday = "MONDAY"
        case tuesday = "TUESDAY"
        case wednesday = "WEDNESDAY"
        case thursday = "THURSDAY"
        case friday = "FRIDAY"
        case saturday = "SATURDAY"
    }

    private static func unlocalizedWeekday(for date: Date) -> String? {
        let calendar = Calendar(identifier: .gregorian).with(\.timeZone, Current.timeZone)
        let weekday = calendar.component(.weekday, from: date)
        let index = weekday - 1
        return UnlocalizedWeekday.allCases[safe: index]?.rawValue
    }

    private static func time(for date: Date) -> String? {
        DateFormatter()
            .with(\.timeZone, Current.timeZone)
            .with(\.dateFormat, "HH:mm")
            .string(from: date)
    }
}
