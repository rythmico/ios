import SwiftUIEncore

struct LessonPlanSummaryTutorStatusView: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let lessonPlan: LessonPlan
    let backgroundColor: Color?

    var applications: LessonPlan.Applications? { lessonPlan.applications }
    var bookingInfo: LessonPlan.BookingInfo? { lessonPlan.bookingInfo }
    var status: LessonPlan.Status { lessonPlan.status }

    var body: some View {
        InlineContentTitleView(content: { avatar.fixedSize() }, title: title)
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

    var title: String {
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
                LessonPlanSummaryTutorStatusView(
                    lessonPlan: .stub => (\.status, combo.1),
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
