import Foundation
import FoundationSugar
import Then

extension AnalyticsEvent {
    static func screenView(_ step: RequestLessonPlanFlow.Step, in flow: RequestLessonPlanFlow) -> Self {
        Self(name: "[Screenview] \(screenName(step))", props: screenProps(step) + flowProps(flow))
    }

    private static func screenName(_ step: RequestLessonPlanFlow.Step) -> String {
        switch step {
        case .instrumentSelection:
            return "Request Plan Flow - Choose Instrument"
        case .studentDetails:
            return "Request Plan Flow - Student Details"
        case .addressDetails:
            return "Request Plan Flow - Address Details"
        case .scheduling:
            return "Request Plan Flow - Lesson Schedule"
        case .privateNote:
            return "Request Plan Flow - Private Note"
        case .reviewRequest:
            return "Request Plan Flow - Review Request"
        }
    }

    private static func screenProps(_ step: RequestLessonPlanFlow.Step) -> Props {
        switch step {
        case .instrumentSelection:
            return lessonPlanProps(nil, nil, nil, nil)

        case let .studentDetails(instrument):
            return lessonPlanProps(instrument, nil, nil, nil)

        case let .addressDetails(instrument, student):
            return lessonPlanProps(instrument, student, nil, nil)

        case let .scheduling(instrument, student, address):
            return lessonPlanProps(instrument, student, address, nil)

        case let .privateNote(instrument, student, address, schedule):
            return lessonPlanProps(instrument, student, address, schedule)

        case let .reviewRequest(instrument, student, address, schedule, _):
            return lessonPlanProps(instrument, student, address, schedule)
        }
    }

    static func flowProps(_ flow: RequestLessonPlanFlow) -> Props {
        ["Request Plan Flow ID": flow.id.uuidString]
    }
}
