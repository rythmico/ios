import SwiftUI

extension InlineContentAndTitleView where Content == AnyView {
    init(status: LessonPlan.Status, summarized: Bool) {
        self.init(
            content: { AnyView(status.avatar) },
            title: summarized ? status.summarizedTitle : status.title,
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
            AvatarStackView(applications.map(\.tutor), thumbnails: true)
        case .scheduled(_, let tutor),
             .cancelled(_, let tutor?, _):
            LessonPlanTutorAvatarView(tutor, mode: .thumbnail)
        case .cancelled(_, nil, _):
            AvatarView(.placeholder)
        }
    }

    var summarizedTitle: String {
        switch self {
        case .pending,
             .reviewing([]):
            return "Tutor TBC"
        case .reviewing(let applications):
            return "\(applications.count) applied"
        case .scheduled(_, let tutor),
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
            return "Pending tutor applications"
        case .reviewing(let applications):
            let count = applications.count
            return "\(count) tutor\(count == 1 ? "" : "s") applied" // TODO: plurals
        case .scheduled(_, let tutor),
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
            InlineContentAndTitleView(status: .pending, summarized: true)
                .previewDisplayName("Pending")
            InlineContentAndTitleView(status: .reviewing([]), summarized: true)
                .previewDisplayName("Reviewing 0 Tutors")
            InlineContentAndTitleView(status: .reviewing(.stub), summarized: true)
                .previewDisplayName("Reviewing 1+ Tutors")
            InlineContentAndTitleView(status: .scheduled(.stub, .jesseStub), summarized: true)
                .previewDisplayName("Scheduled")
            InlineContentAndTitleView(status: .cancelled(.stub, nil, .stub), summarized: true)
                .previewDisplayName("Cancelled no Tutor")
            InlineContentAndTitleView(status: .cancelled(.stub, .jesseStub, .stub), summarized: true)
                .previewDisplayName("Cancelled w/ Tutor")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
