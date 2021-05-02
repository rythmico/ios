import SwiftUI
import MultiModal
import FoundationSugar

struct LessonDetailView: View, TestableView {
    @ObservedObject
    private var state = Current.state

    var lesson: Lesson
    var lessonPlan: LessonPlan? { Current.lessonPlanRepository.firstById(lesson.lessonPlanId) }

    var lessonReschedulingView: LessonReschedulingView? { lessonPlan?.status.isCancelled == false ? .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) : nil }
    var lessonSkippingView: LessonSkippingView? { LessonSkippingView(lesson: lesson) }
    var lessonPlanCancellationView: LessonPlanCancellationView? { lessonPlan.flatMap(LessonPlanCancellationView.init) }

    @State
    private var isRescheduling = false // TODO: move to AppState
    var showRescheduleAlertAction: Action? {
        lessonReschedulingView != nil
            ? { isRescheduling = true }
            : nil
    }

    var showSkipLessonFormAction: Action? {
        lessonSkippingView != nil
            ? { state.lessonsContext.isSkippingLesson = true }
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
                TitleContentView(title: lesson.title) {
                    Pill(status: lesson.status)
                }
                .padding(.horizontal, .spacingMedium)

                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingMedium) {
                        SectionHeaderView(title: "Lesson Details")
                        LessonScheduleView(lesson: lesson)
                        HStack(alignment: .firstTextBaseline, spacing: .spacingUnit * 2) {
                            Image(decorative: Asset.iconLocation.name)
                                .renderingMode(.template)
                                .offset(y: .spacingUnit / 2)
                            Text(lesson.address.condensedFormattedString)
                                .rythmicoTextStyle(.body)
                        }

                        SectionHeaderView(title: "Tutor")
                        TutorCell(tutor: lesson.tutor)
                    }
                    .foregroundColor(.rythmicoGray90)
                    .padding(.horizontal, .spacingMedium)
                }
            }
            .frame(maxWidth: .spacingMax)

            ActionList(actions, showBottomSeparator: false)
                .foregroundColor(.rythmicoGray90)
        }
        .testable(self)
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) }
            $0.sheet(isPresented: $state.lessonsContext.isSkippingLesson) { lessonSkippingView }
            $0.sheet(isPresented: $state.lessonsContext.isCancellingLessonPlan) { lessonPlanCancellationView }
        }
    }

    @ArrayBuilder<ActionList.Button>
    private var actions: [ActionList.Button] {
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule", action: action)
        }
        if let action = showSkipLessonFormAction {
            .init(title: "Skip Lesson", action: action)
        }
        if let action = showCancelLessonPlanFormAction {
            .init(title: "Cancel Lesson Plan", action: action)
        }
    }
}

#if DEBUG
struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: .scheduledStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
