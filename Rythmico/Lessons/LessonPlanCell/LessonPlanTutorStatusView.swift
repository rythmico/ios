import SwiftUI

struct LessonPlanTutorStatusView: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let lessonPlan: LessonPlan
    let summarized: Bool
    let backgroundColor: Color

    var status: LessonPlan.Status { lessonPlan.status }
    var applications: LessonPlan.Applications? { lessonPlan.applications }
    var bookingInfo: LessonPlan.BookingInfo? { lessonPlan.bookingInfo }

    var body: some View {
        InlineContentAndTitleView(
            content: { avatar },
            title: summarized ? summarizedTitle : title,
            bold: !summarized
        )
    }

    @ViewBuilder
    var avatar: some View {
        if let applications = applications {
            AvatarStackView(data: applications.map(\.tutor), thumbnails: true, backgroundColor: backgroundColor)
        } else if let tutor = bookingInfo?.tutor {
            TutorAvatarView(tutor, mode: .thumbnail)
        } else {
            AvatarView(.placeholder)
        }
    }

    var summarizedTitle: String {
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
    static let combos: [(String, LessonPlan.Status)] = [
        ("Pending", .pending),
        ("Reviewing Tutors", .reviewing(.stub)),
        ("Scheduled", .active(.stub)),
        ("Cancelled no Tutor", .cancelled(.noTutorStub)),
        ("Cancelled w/ Tutor", .cancelled(.stub)),
    ]

    static var previews: some View {
        Group {
            ForEach(combos, id: \.self.0) { combo in
                LessonPlanTutorStatusView(
                    lessonPlan: .stub.with(\.status, combo.1),
                    summarized: true,
                    backgroundColor: .rythmico.background
                )
                .previewDisplayName(combo.0)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
