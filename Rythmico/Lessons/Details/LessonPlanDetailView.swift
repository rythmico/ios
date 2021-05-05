import SwiftUI
import MultiModal
import FoundationSugar

struct LessonPlanDetailView: View, TestableView {
    var lessonPlan: LessonPlan
    private var context: AppState.LessonsContext {
        get { contextBinding.wrappedValue }
        nonmutating set { contextBinding.wrappedValue = newValue }
    }
    private var contextBinding: Binding<AppState.LessonsContext> { externalContext ?? $internalContext }
    private var externalContext: Binding<AppState.LessonsContext>?
    @State
    private var internalContext: AppState.LessonsContext = .none

    init(lessonPlan: LessonPlan, context: Binding<AppState.LessonsContext>?) {
        self.lessonPlan = lessonPlan
        self.externalContext = context
    }

    var title: String {
        [lessonPlan.student.name.firstWord, "\(lessonPlan.instrument.assimilatedName) Lessons"]
            .compact()
            .joined(separator: " - ")
    }

    var lessonPlanReschedulingView: LessonReschedulingView? { !lessonPlan.status.isCancelled ? .reschedulingView(lessonPlan: lessonPlan) : nil }
    var lessonPlanCancellationView: LessonPlanCancellationView? { LessonPlanCancellationView(lessonPlan: lessonPlan) }

    var chooseTutorAction: Action? {
        lessonPlan.status.isReviewing
            ? { context = .reviewingLessonPlan(lessonPlan, .none) }
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
            ? { context = .viewingLessonPlan(lessonPlan, isCancelling: true) }
            : nil
    }

    let inspection = SelfInspection()
    var body: some View {
        ZStack {
            ZStack {
                Image(uiImage: lessonPlan.instrument.icon.image.resized(width: 200))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .opacity(0.08)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .offset(x: 40, y: -70)

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

                FloatingActionMenu(buttons)
            }
        }
        .testable(self)
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lessonPlan: lessonPlan) }
            $0.sheet(isPresented: contextBinding.isCancellingLessonPlan) { lessonPlanCancellationView }
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
    private var buttons: [FloatingActionMenu.Button] {
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
        LessonPlanDetailView(lessonPlan: .jesseDrumsPlanStub, context: nil)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
