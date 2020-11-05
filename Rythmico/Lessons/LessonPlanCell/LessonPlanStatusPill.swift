import SwiftUI

extension Pill where Content == AnyView {
    init(status: LessonPlan.Status) {
        self.init(
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
            return "Review"
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
            return .rythmicoDarkBurgundy
        case .scheduled:
            return .clear
        case .cancelled:
            return Color(lightModeVariantHex: 0x111619, darkModeVariantHex: 0x9fa1a3)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .pending:
            return .rythmicoLightPurple
        case .reviewing:
            return .rythmicoLightBurgundy
        case .scheduled:
            return .clear
        case .cancelled:
            return Color(lightModeVariantHex: 0xDDE1E6, darkModeVariantHex: 0x424345)
        }
    }
}
