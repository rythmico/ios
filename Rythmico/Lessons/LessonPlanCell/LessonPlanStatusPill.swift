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
        case .reviewing(let applications):
            return "\(applications.count) Applied"
        case .scheduled:
            return "Active"
        case .cancelled:
            return "Cancelled"
        }
    }

    var titleColor: Color {
        switch self {
        case .pending:
            return .rythmicoDarkPurple
        case .reviewing:
            return .rythmicoDarkBurgundy
        case .scheduled:
            return .rythmicoDarkGreen
        case .cancelled:
            return Color(lightModeVariantHex: 0x111619, darkModeVariantHex: 0x9fa1a3)
        }
    }

    var borderColor: Color {
        switch self {
        case .pending:
            return .rythmicoDarkPurple
        case .reviewing:
            return .rythmicoDarkBurgundy
        case .scheduled:
            return .rythmicoDarkGreen
        case .cancelled:
            return Color(lightModeVariantHex: 0x111619, darkModeVariantHex: 0x9fa1a3)
        }
    }
}
