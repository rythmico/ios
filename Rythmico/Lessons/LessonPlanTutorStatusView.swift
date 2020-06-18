import SwiftUI

struct LessonPlanTutorStatusView: View {
    var status: LessonPlan.Status
    var summarized: Bool

    init(_ status: LessonPlan.Status, summarized: Bool) {
        self.status = status
        self.summarized = summarized
    }

    var body: some View {
        CircleImageTitleView(
            image: status.image,
            imageBackgroundColor: status.imageBackgroundColor,
            title: summarized ? status.summarizedTitle : status.title,
            bold: !summarized
        )
    }
}

private struct CircleImageTitleView: View {
    var image: AnyView
    var imageBackgroundColor: Color
    var title: String
    var bold: Bool

    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            image
                .frame(width: 32, height: 32)
                .background(imageBackgroundColor.clipShape(Circle()))
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .rythmicoFont(bold ? .bodySemibold : .body)
                .foregroundColor(.rythmicoGray90)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private extension LessonPlan.Status {
    var image: AnyView {
        switch self {
        case .pending, .cancelled(nil, _):
            return AnyView(
                Image(systemSymbol: .person)
                    .foregroundColor(.rythmicoGray90)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            )
        default:
            return AnyView(Image(systemSymbol: .personFill)) // TODO
        }
    }

    var imageBackgroundColor: Color {
        switch self {
        case .cancelled(nil, _):
            return Color(
                UIColor(
                    lightModeVariant: .init(hex: 0xDDE1E6),
                    darkModeVariant: .init(hex: 0x424345)
                )
            )
        default:
            return .rythmicoGray10
        }
    }

    var summarizedTitle: String {
        switch self {
        case .pending:
            return "Tutor TBC"
        case .cancelled(nil, _):
            return "No tutor"
        default:
            return "" // TODO
        }
    }

    var title: String {
        switch self {
        case .pending:
            return "Pending tutor applications"
        case .cancelled(nil, _):
            return "No tutor was selected"
        default:
            return "" // TODO
        }
    }
}
