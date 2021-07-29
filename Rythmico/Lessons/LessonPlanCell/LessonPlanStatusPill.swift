import SwiftUI

extension Pill where Content == AnyView {
    init(lessonPlan: LessonPlan) {
        self.init(
            title: lessonPlan.status.title,
            titleColor: lessonPlan.status.titleColor,
            backgroundColor: lessonPlan.status.backgroundColor,
            borderColor: .clear
        )
    }
}

private extension LessonPlan.Status {
    var title: String {
        switch self {
        case .pending:
            return "Pending"
        case .reviewing(let props):
            return "\(props.applications.count) Applied"
        case .active:
            return "Active"
        case .paused:
            return "Paused"
        case .cancelled:
            return "Cancelled"
        }
    }

    var titleColor: Color {
        switch self {
        case .pending:
            return .rythmico.tagTextPurple
        case .reviewing:
            return .rythmico.tagTextBurgundy
        case .active:
            return .rythmico.tagTextGreen
        case .paused:
            return .rythmico.tagTextBlue
        case .cancelled:
            return .rythmico.tagTextGray
        }
    }

    var backgroundColor: Color {
        switch self {
        case .pending:
            return .rythmico.tagPurple
        case .reviewing:
            return .rythmico.tagBurgundy
        case .active:
            return .rythmico.tagGreen
        case .paused:
            return .rythmico.tagBlue
        case .cancelled:
            return .rythmico.tagGray
        }
    }
}
