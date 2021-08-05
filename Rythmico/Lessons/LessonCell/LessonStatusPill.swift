import SwiftUI

extension Pill where Content == AnyView {
    init(status: Lesson.Status) {
        self.init(
            title: status.title,
            titleColor: status.titleColor,
            backgroundColor: status.backgroundColor,
            borderColor: .clear
        )
    }
}

private extension Lesson.Status {
    var title: String {
        switch self {
        case .scheduled:
            return "Scheduled"
        case .skipped:
            return "Skipped"
        case .paused:
            return "Paused"
        case .cancelled:
            return "Cancelled"
        case .completed:
            return "Completed"
        }
    }

    var titleColor: Color {
        switch self {
        case .scheduled:
            return .rythmico.tagTextBlue
        case .skipped:
            return .rythmico.tagTextGray
        case .paused:
            return .rythmico.tagTextGray
        case .cancelled:
            return .rythmico.tagTextGray
        case .completed:
            return .rythmico.tagTextGreen
        }
    }

    var backgroundColor: Color {
        switch self {
        case .scheduled:
            return .rythmico.tagBlue
        case .skipped:
            return .rythmico.tagGray
        case .paused:
            return .rythmico.tagGray
        case .cancelled:
            return .rythmico.tagGray
        case .completed:
            return .rythmico.tagGreen
        }
    }
}

#if DEBUG
struct LessonStatusPill_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Pill(status: Lesson.scheduledStub.status)
            Pill(status: Lesson.skippedStub.status)
            Pill(status: Lesson.completedStub.status)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
