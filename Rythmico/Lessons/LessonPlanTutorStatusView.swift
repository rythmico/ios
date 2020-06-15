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
            title: summarized ? status.summarizedTitle : status.title,
            bold: !summarized
        )
    }
}

private struct CircleImageTitleView: View {
    var image: AnyView
    var title: String
    var bold: Bool

    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            image
                .frame(width: 32, height: 32)
                .background(Color.rythmicoGray10.clipShape(Circle()))
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
        case .pending:
            return AnyView(Image(systemSymbol: .person).foregroundColor(.rythmicoGray90).font(.system(size: 18, weight: .semibold, design: .rounded)))
        default:
            return AnyView(Image(systemSymbol: .personFill)) // TODO
        }
    }

    var summarizedTitle: String {
        switch self {
        case .pending:
            return "Tutor TBC"
        default:
            return "" // TODO
        }
    }

    var title: String {
        switch self {
        case .pending:
            return "Pending tutor applications"
        default:
            return "" // TODO
        }
    }
}
