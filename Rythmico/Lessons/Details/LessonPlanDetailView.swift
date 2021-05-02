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
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingMedium) {
                        SectionHeaderView(title: "Plan Details")
                        LessonPlanScheduleView(lessonPlan: lessonPlan)
                        HStack(alignment: .firstTextBaseline, spacing: .spacingUnit * 2) {
                            Image(decorative: Asset.iconLocation.name)
                                .renderingMode(.template)
                                .offset(y: .spacingUnit / 2)
                            Text(lessonPlan.address.condensedFormattedString)
                                .rythmicoTextStyle(.body)
                        }

                        SectionHeaderView(title: "Tutor")
                        InlineContentAndTitleView(status: lessonPlan.status, summarized: false)
                        if lessonPlan.status.isPending {
                            InfoBanner(text: "Potential tutors have received your request and will submit applications for your consideration.")
                        }
                    }
                    .foregroundColor(.rythmicoGray90)
                }
            }
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingMedium)

            FloatingView {
                HStack(spacing: .spacingSmall, content: actionButtons)
            }
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
    private func actionButtons() -> some View {
        if let action = showRescheduleAlertAction {
            RythmicoButton("Reschedule", style: RythmicoButtonStyle.secondary(), action: action)
        }
        if let action = showCancelLessonPlanFormAction {
            Menu {
                Button("Cancel Lesson Plan", action: action)
            } label: {
                RythmicoButton("More...", style: RythmicoButtonStyle.tertiary(), action: {})
            }
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
