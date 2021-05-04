import SwiftUI
import MultiModal
import FoundationSugar

struct LessonPlanDetailView: View, TestableView {
    @ObservedObject
    private var state = Current.state

    var lessonPlan: LessonPlan

    var title: String {
        [lessonPlan.student.name.firstWord, "\(lessonPlan.instrument.assimilatedName) Lessons"]
            .compact()
            .joined(separator: " - ")
    }

    var lessonPlanReschedulingView: LessonReschedulingView? { !lessonPlan.status.isCancelled ? .reschedulingView(lessonPlan: lessonPlan) : nil }
    var lessonPlanCancellationView: LessonPlanCancellationView? { LessonPlanCancellationView(lessonPlan: lessonPlan) }

    var chooseTutorAction: Action? {
        lessonPlan.status.isReviewing
            ? { state.lessonsContext = .reviewingLessonPlan(lessonPlan, .none) }
            : nil
    }

    @State
    private var isRescheduling = false // TODO: move to AppState
    var showRescheduleAlertAction: Action? {
        lessonPlanReschedulingView != nil
            ? { isRescheduling = true }
            : nil
    }

    var showCancelLessonPlanFormAction: Action? {
        lessonPlanCancellationView != nil
            ? { state.lessonsContext.isCancellingLessonPlan = true }
            : nil
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .spacingExtraLarge) {
                TitleContentView(title: title) {
                    Pill(lessonPlan: lessonPlan)
                }
                .padding(.horizontal, .spacingMedium)

                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingMedium) {
                        SectionHeaderView(title: "Plan Details")
                        LessonPlanScheduleView(lessonPlan: lessonPlan)
                        AddressLabel(address: lessonPlan.address)

                        SectionHeaderView(title: "Tutor")
                        tutorContent()
                    }
                    .foregroundColor(.rythmicoGray90)
                    .padding(.horizontal, .spacingMedium)
                }
            }
            .frame(maxWidth: .spacingMax)

            FloatingActionMenu(actionButtons)
        }
        .testable(self)
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lessonPlan: lessonPlan) }
            $0.sheet(isPresented: $state.lessonsContext.isCancellingLessonPlan) { lessonPlanCancellationView }
        }
    }

    @ViewBuilder
    private func tutorContent() -> some View {
        switch lessonPlan.status {
        case .pending, .reviewing, .cancelled(_, .none, _):
            LessonPlanTutorStatusView(status: lessonPlan.status, summarized: false)
            if lessonPlan.status.isPending {
                InfoBanner(text: "Potential tutors have received your request and will submit applications for your consideration.")
            }
        case .scheduled(_, let tutor), .cancelled(_, let tutor?, _):
            TutorCell(tutor: tutor)
        }
    }

    @ArrayBuilder<FloatingActionMenu.Button>
    private var actionButtons: [FloatingActionMenu.Button] {
        if let action = chooseTutorAction {
            .init(title: "Choose Tutor", isPrimary: true, action: action)
        }
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule", action: action)
        }
        if let action = showCancelLessonPlanFormAction {
            .init(title: "Cancel Plan", action: action)
        }
    }
}

#if DEBUG
struct LessonPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanDetailView(lessonPlan: .jesseDrumsPlanStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
