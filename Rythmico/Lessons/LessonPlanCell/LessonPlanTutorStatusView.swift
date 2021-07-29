import SwiftUI

struct LessonPlanTutorStatusView: View {
    @Environment(\.sizeCategory) private var sizeCategory

    var lessonPlan: LessonPlan
    var summarized: Bool

    var body: some View {
        InlineContentAndTitleView(
            content: { lessonPlan.avatar },
            title: summarized ? lessonPlan.summarizedTitle(sizeCategory: sizeCategory) : lessonPlan.title,
            bold: !summarized
        )
    }
}

private extension LessonPlan {
    @ViewBuilder
    var avatar: some View {
        if let applications = applications {
            AvatarStackView(data: applications.map(\.tutor), thumbnails: true)
        } else if let tutor = bookingInfo?.tutor {
            TutorAvatarView(tutor, mode: .thumbnail)
        } else {
            AvatarView(.placeholder)
        }
    }

    func summarizedTitle(sizeCategory: ContentSizeCategory) -> String {
        if status.isPending {
            return ""
        } else if let applications = applications {
            return applications.count == 1 && !sizeCategory.isAccessibilityCategory ? "Tutors Available" : .empty
        } else if let tutor = bookingInfo?.tutor {
            return tutor.name
        } else {
            return "No tutor"
        }
    }

    var title: String {
        if status.isPending {
            return "Pending tutor applications..."
        } else if let applicationCount = applications?.count {
            let suffix = applicationCount == 1 ? "" : "s" // TODO: proper plurals
            return "\(applicationCount) tutor\(suffix) applied"
        } else if let tutor = bookingInfo?.tutor {
            return tutor.name
        } else {
            return "No tutor was selected"
        }
    }
}

#if DEBUG
struct LessonPlanTutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanTutorStatusView(lessonPlan: .stub.with(\.status, .pending), summarized: true)
                .previewDisplayName("Pending")
            LessonPlanTutorStatusView(lessonPlan: .stub.with(\.status, .reviewing(.stub)), summarized: true)
                .previewDisplayName("Reviewing Tutors")
            LessonPlanTutorStatusView(lessonPlan: .stub.with(\.status, .active(.stub)), summarized: true)
                .previewDisplayName("Scheduled")
            LessonPlanTutorStatusView(lessonPlan: .stub.with(\.status, .cancelled(.noTutorStub)), summarized: true)
                .previewDisplayName("Cancelled no Tutor")
            LessonPlanTutorStatusView(lessonPlan: .stub.with(\.status, .cancelled(.stub)), summarized: true)
                .previewDisplayName("Cancelled w/ Tutor")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
