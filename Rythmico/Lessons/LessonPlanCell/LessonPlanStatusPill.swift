import SwiftUI

extension Pill where Content == AnyView {
    init(lessonPlan: LessonPlan, backgroundColor: Color) {
        self.init(
            title: lessonPlan.status.title,
            titleColor: lessonPlan.status.titleColor,
            backgroundColor: backgroundColor,
            borderColor: lessonPlan.status.borderColor
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
            return .rythmico.darkPurple
        case .reviewing:
            return .rythmico.darkBurgundy
        case .active:
            return .rythmico.darkGreen
        case .paused:
            return .rythmico.darkBlue
        case .cancelled:
            return Color(light: 0x111619, dark: 0x9fa1a3)
        }
    }

    var borderColor: Color {
        switch self {
        case .pending:
            return .rythmico.darkPurple
        case .reviewing:
            return .rythmico.darkBurgundy
        case .active:
            return .rythmico.darkGreen
        case .paused:
            return .rythmico.darkBlue
        case .cancelled:
            return Color(light: 0x111619, dark: 0x9fa1a3)
        }
    }
}
