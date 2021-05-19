import SwiftUI

struct LessonPlanTutorStatusView: View {
    @Environment(\.sizeCategory) private var sizeCategory

    var status: LessonPlan.Status
    var summarized: Bool

    var body: some View {
        InlineContentAndTitleView(
            content: { AnyView(status.avatar) },
            title: summarized ? status.summarizedTitle(sizeCategory: sizeCategory) : status.title,
            bold: !summarized
        )
    }
}

private extension LessonPlan.Status {
    @ViewBuilder
    var avatar: some View {
        switch self {
        case .pending,
             .reviewing([]):
            AvatarView(.placeholder)
        case .reviewing(let applications):
            AvatarStackView(data: applications.map(\.tutor), thumbnails: true)
        case .active(_, let tutor),
             .paused(_, let tutor, _),
             .cancelled(_, let tutor?, _):
            TutorAvatarView(tutor, mode: .thumbnail)
        case .cancelled(_, nil, _):
            AvatarView(.placeholder)
        }
    }

    func summarizedTitle(sizeCategory: ContentSizeCategory) -> String {
        switch self {
        case .pending,
             .reviewing([]):
            return "Tutor TBC"
        case .reviewing(let applicants):
            return applicants.count == 1 && !sizeCategory.isAccessibilityCategory ? "Tutors Available" : .empty
        case .active(_, let tutor),
             .paused(_, let tutor, _),
             .cancelled(_, let tutor?, _):
            return tutor.name
        case .cancelled(_, nil, _):
            return "No tutor"
        }
    }

    var title: String {
        switch self {
        case .pending,
             .reviewing([]):
            return "Pending tutor applications..."
        case .reviewing(let applications):
            let count = applications.count
            return "\(count) tutor\(count == 1 ? "" : "s") applied" // TODO: plurals
        case .active(_, let tutor),
             .paused(_, let tutor, _),
             .cancelled(_, let tutor?, _):
            return tutor.name
        case .cancelled(_, nil, _):
            return "No tutor was selected"
        }
    }
}

#if DEBUG
struct LessonPlanTutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanTutorStatusView(status: .pending, summarized: true)
                .previewDisplayName("Pending")
            LessonPlanTutorStatusView(status: .reviewing([]), summarized: true)
                .previewDisplayName("Reviewing 0 Tutors")
            LessonPlanTutorStatusView(status: .reviewing(.stub), summarized: true)
                .previewDisplayName("Reviewing 1+ Tutors")
            LessonPlanTutorStatusView(status: .active(.stub, .jesseStub), summarized: true)
                .previewDisplayName("Scheduled")
            LessonPlanTutorStatusView(status: .cancelled(.stub, nil, .stub), summarized: true)
                .previewDisplayName("Cancelled no Tutor")
            LessonPlanTutorStatusView(status: .cancelled(.stub, .jesseStub, .stub), summarized: true)
                .previewDisplayName("Cancelled w/ Tutor")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
