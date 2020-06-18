import SwiftUI

struct LessonPlanStatusPill: View {
    var status: LessonPlan.Status

    init(_ status: LessonPlan.Status) {
        self.status = status
    }

    var body: some View {
        TextPill(
            title: status.title,
            titleColor: status.titleColor,
            backgroundColor: status.backgroundColor
        )
    }
}

private extension LessonPlan.Status {
    var title: String {
        switch self {
        case .pending:
            return "Pending"
        case .reviewing:
            return "Reviewing"
        case .scheduled:
            return "Scheduled"
        case .cancelled:
            return "Cancelled"
        }
    }

    var titleColor: Color {
        switch self {
        case .pending:
            return .rythmicoDarkPurple
        case .reviewing:
            return .clear
        case .scheduled:
            return .clear
        case .cancelled:
            return .rythmicoGray90
        }
    }

    var backgroundColor: Color {
        switch self {
        case .pending:
            return .rythmicoLightPurple
        case .reviewing:
            return .clear
        case .scheduled:
            return .clear
        case .cancelled:
            return .rythmicoGray10
        }
    }
}
