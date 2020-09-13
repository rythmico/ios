import SwiftUI

struct LessonPlanTutorStatusView: View {
    var status: LessonPlan.Status
    var summarized: Bool

    init(_ status: LessonPlan.Status, summarized: Bool) {
        self.status = status
        self.summarized = summarized
    }

    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            status.avatar
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .rythmicoFont(bold ? .bodySemibold : .body)
                .foregroundColor(.rythmicoGray90)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var title: String {
        summarized ? status.summarizedTitle : status.title
    }

    private var bold: Bool {
        !summarized
    }
}

private extension LessonPlan.Status {
    var avatar: AnyView {
        switch self {
        case .pending,
             .reviewing([]):
            return AnyView(AvatarView(.placeholder))
        case .reviewing(let applications):
            return AnyView(AvatarStackView(applications.map(\.tutor), thumbnails: true))
        case .scheduled(let tutor),
             .cancelled(let tutor?, _):
            return AnyView(LessonPlanTutorAvatarView(tutor, thumbnail: true))
        case .cancelled(nil, _):
            return AnyView(AvatarView(.placeholder))
        }
    }

    var summarizedTitle: String {
        switch self {
        case .pending,
             .reviewing([]):
            return "Tutor TBC"
        case .reviewing(let applications):
            return "\(applications.count) applied"
        case .scheduled(let tutor),
             .cancelled(let tutor?, _):
            return tutor.name
        case .cancelled(nil, _):
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
        case .scheduled(let tutor),
             .cancelled(let tutor?, _):
            return tutor.name
        case .cancelled(nil, _):
            return "No tutor was selected"
        }
    }
}

#if DEBUG
struct LessonPlanTutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanTutorStatusView(.pending, summarized: true)
                .previewDisplayName("Pending")
            LessonPlanTutorStatusView(.reviewing([]), summarized: true)
                .previewDisplayName("Reviewing 0 Tutors")
            LessonPlanTutorStatusView(.reviewing(.stub), summarized: true)
                .previewDisplayName("Reviewing 1+ Tutors")
            LessonPlanTutorStatusView(.scheduled(.jesseStub), summarized: true)
                .previewDisplayName("Scheduled")
            LessonPlanTutorStatusView(.cancelled(nil, .stub), summarized: true)
                .previewDisplayName("Cancelled no Tutor")
            LessonPlanTutorStatusView(.cancelled(.jesseStub, .stub), summarized: true)
                .previewDisplayName("Cancelled w/ Tutor")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
