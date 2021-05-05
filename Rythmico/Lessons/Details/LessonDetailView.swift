import SwiftUI
import MultiModal
import FoundationSugar

struct LessonDetailView: View, TestableView {
    @ObservedObject
    private var state = Current.state

    var lesson: Lesson
    var lessonPlan: LessonPlan? { Current.lessonPlanRepository.firstById(lesson.lessonPlanId) }

    var lessonPlanDetailView: LessonPlanDetailView? { lessonPlan.flatMap { LessonPlanDetailView(lessonPlan: $0, context: nil) } }
    var lessonReschedulingView: LessonReschedulingView? { lessonPlan?.status.isCancelled == false ? .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) : nil }
    var lessonSkippingView: LessonSkippingView? { LessonSkippingView(lesson: lesson) }

    @State
    private var isShowingPlanDetail = false
    var showLessonPlanDetailAction: Action? {
        lessonPlanDetailView != nil
            ? { isShowingPlanDetail = true }
            : nil
    }

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
                        AddressLabel(address: lesson.address)

                        SectionHeaderView(title: "Tutor")
                        TutorCell(tutor: lesson.tutor)
                    }
                    .foregroundColor(.rythmicoGray90)
                    .padding(.horizontal, .spacingMedium)
                }
            }
            .frame(maxWidth: .spacingMax)

            FloatingActionMenu(buttons)
        }
        .testable(self)
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .detail(isActive: $isShowingPlanDetail) { lessonPlanDetailView }
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lesson: lesson, lessonPlan: lessonPlan) }
            $0.sheet(isPresented: $state.lessonsContext.isSkippingLesson) { lessonSkippingView }
        }
    }

    @ArrayBuilder<FloatingActionMenu.Button>
    private var buttons: [FloatingActionMenu.Button] {
        if let action = showLessonPlanDetailAction {
            .init(title: "View Plan", isPrimary: true, action: action)
        }
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule Lesson", action: action)
        }
        if let action = showSkipLessonFormAction {
            .init(title: "Skip Lesson", action: action)
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
