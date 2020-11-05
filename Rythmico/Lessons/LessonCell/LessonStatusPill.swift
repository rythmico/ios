import SwiftUI

extension Pill where Content == AnyView {
    init(status: Lesson.Status) {
        self.init(
            title: status.title,
            titleColor: status.titleColor,
            backgroundColor: status.backgroundColor
        )
    }
}

private extension Lesson.Status {
    var title: String {
        switch self {
        case .scheduled:
            return "Scheduled"
        case .cancelled:
            return "Cancelled"
        case .completed:
            return "Completed"
        }
    }

    var titleColor: Color {
        switch self {
        case .scheduled:
            return .rythmicoDarkBlue
        case .cancelled:
            return Color(lightModeVariantHex: 0x111619, darkModeVariantHex: 0x9fa1a3)
        case .completed:
            return .rythmicoDarkGreen
        }
    }

    var backgroundColor: Color {
        switch self {
        case .scheduled:
            return .rythmicoLightBlue
        case .cancelled:
            return Color(lightModeVariantHex: 0xDDE1E6, darkModeVariantHex: 0x424345)
        case .completed:
            return .rythmicoLightGreen
        }
    }
}

#if DEBUG
struct LessonStatusPill_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Pill(status: Lesson.scheduledStub.status)
            Pill(status: Lesson.cancelledStub.status)
            Pill(status: Lesson.completedStub.status)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
