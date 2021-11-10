import FoundationEncore
import StudentDTO

extension AnalyticsEvent {
    @PropsBuilder
    static func lessonPlanRequestProps(_ lessonPlanRequest: LessonPlanRequest) -> Props {
        ["Lesson Plan Request ID": lessonPlanRequest.id.rawValue]
        lessonPlanRequestProps(
            lessonPlanRequest.instrument,
            lessonPlanRequest.student,
            lessonPlanRequest.address,
            lessonPlanRequest.schedule
        )
    }

    @PropsBuilder
    static func lessonPlanRequestProps(
        _ instrument: Instrument?,
        _ student: Student?,
        _ address: AddressProtocol?,
        _ schedule: LessonPlanRequestSchedule?
    ) -> Props {
        if let instrument = instrument {
            ["Instrument": instrument.id.rawValue]
        }
        if let student = student {
            ["Student Age": try! Current.dateOnly() - (student.dateOfBirth, .year)]
        }
        if let postcodeDistrict = address?.postcode.firstWord {
            ["Address District": postcodeDistrict]
        }
        if let schedule = schedule {
            ["Lesson Day": schedule.start.formatted(custom: "EEEE", locale: .neutral)]
            ["Lesson Time": schedule.time.formatted(style: .iso8601)]
            ["Lesson Duration": schedule.duration.formatted(style: .iso8601)]
        }
    }
}
