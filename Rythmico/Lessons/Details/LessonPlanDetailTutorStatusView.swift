import SwiftUISugar

struct LessonPlanDetailTutorStatusView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lessonPlan: LessonPlan

    var applications: LessonPlan.Applications? { lessonPlan.applications }
    var bookingInfo: LessonPlan.BookingInfo? { lessonPlan.bookingInfo }
    var status: LessonPlan.Status { lessonPlan.status }

    var body: some View {
        AdHocButton(action: action ?? {}) { state in
            SelectableContainer(
                fill: .rythmico.background,
                isSelected: state == .pressed
            ) { state in
                InlineContentTitleSubtitleView(
                    content: { avatar(backgroundColor: state.backgroundColor) },
                    title: title,
                    subtitle: subtitle
                )
                .padding(.grid(5))
            }
        }
        .disabled(action == nil)
    }

    @ViewBuilder
    func avatar(backgroundColor: Color?) -> some View {
        if let applications = applications {
            AvatarStackView(
                data: applications.map(\.tutor),
                thumbnails: true,
                backgroundColor: backgroundColor
            )
        } else if let tutor = bookingInfo?.tutor {
            TutorAvatarView(tutor, mode: .original)
                .frame(maxWidth: .grid(14), maxHeight: .grid(14))
                .withSmallDBSCheck()
        } else {
            AvatarView(.placeholder)
                .frame(maxWidth: 40, maxHeight: 40)
        }
    }

    var title: String {
        if status.isPending {
            return "Pending tutor applications"
        } else if let applications = applications {
            let tutorCount = applications.count
            return tutorCount == 1
                ? "1 tutor has applied"
                : "\(tutorCount) tutors have applied"
        } else if let tutor = bookingInfo?.tutor {
            return tutor.name
        } else {
            return "No tutor"
        }
    }

    var subtitle: String? {
        if status.isPending {
            return "You'll be notified when tutors apply"
        } else {
            return nil
        }
    }

    var action: Action? {
        if let tutor = lessonPlan.bookingInfo?.tutor {
            return {
                navigator.go(
                    to: LessonPlanTutorDetailScreen(lessonPlan: lessonPlan, tutor: tutor),
                    on: currentScreen
                )
            }
        } else if let applicationsScreen = LessonPlanApplicationsScreen(lessonPlan: lessonPlan) {
            return {
                navigator.go(to: applicationsScreen, on: currentScreen)
            }
        } else {
            return nil
        }
    }
}

#if DEBUG
struct LessonPlanDetailTutorStatusView_Previews: PreviewProvider {
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
                LessonPlanDetailTutorStatusView(
                    lessonPlan: .stub.with(\.status, combo.1)
                )
                .previewDisplayName(combo.0)
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
