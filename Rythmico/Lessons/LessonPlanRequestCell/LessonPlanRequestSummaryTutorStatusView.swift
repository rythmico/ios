import StudentDO
import SwiftUIEncore

struct LessonPlanRequestSummaryTutorStatusView: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let lessonPlanRequest: LessonPlanRequest
    let backgroundColor: Color?

    // TODO: upcoming
//    var applications: LessonPlan.Applications? { lessonPlanRequest.applications }
    var status: LessonPlanRequest.Status { lessonPlanRequest.status }

    var body: some View {
        InlineContentTitleView(content: { avatar.fixedSize() }, title: title)
    }

    @ViewBuilder
    var avatar: some View {
        // TODO: upcoming
//        if let applications = applications {
//            AvatarStackView(data: applications.map(\.tutor), thumbnails: true, backgroundColor: backgroundColor)
//        } else {
            AvatarView(.placeholder)
//        }
    }

    var title: String {
        switch status {
        case .pending:
            return ""
        }
        // TODO: upcoming
//        else if let applications = applications {
//            return applications.count == 1 && !sizeCategory.isAccessibilityCategory ? "Tutors Available" : .empty
//        } else {
//            return "No tutor"
//        }
    }
}

#if DEBUG
struct LessonPlanRequestTutorStatusView_Previews: PreviewProvider {
    static let combos: [(String, LessonPlanRequest.Status)] = [
        ("Pending", .pending),
        // TODO: upcoming
//        ("Reviewing Tutors", .reviewing(.stub)),
//        ("Scheduled", .active(.stub)),
//        ("Cancelled no Tutor", .cancelled(.noTutorStub)),
//        ("Cancelled w/ Tutor", .cancelled(.stub)),
    ]

    static var previews: some View {
        Group {
            ForEach(combos, id: \.self.0) { combo in
                LessonPlanRequestSummaryTutorStatusView(
                    lessonPlanRequest: .stub => (\.status, combo.1),
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
