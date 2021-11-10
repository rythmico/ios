import StudentDO
import SwiftUI

extension Pill where Content == AnyView {
    init(lessonPlanRequest: LessonPlanRequest) {
        self.init(
            title: lessonPlanRequest.status.title,
            titleColor: lessonPlanRequest.status.titleColor,
            backgroundColor: lessonPlanRequest.status.backgroundColor,
            borderColor: .clear
        )
    }
}

private extension LessonPlanRequest.Status {
    var title: String {
        switch self {
        case .pending:
            return "Pending"
        }
    }

    var titleColor: Color {
        switch self {
        case .pending:
            return .rythmico.tagTextPurple
        }
    }

    var backgroundColor: Color {
        switch self {
        case .pending:
            return .rythmico.tagPurple
        }
    }
}
