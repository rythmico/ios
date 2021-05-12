import SwiftUI
import MultiModal
import FoundationSugar

struct LessonPlanDetailView: View, TestableView {
    var lessonPlan: LessonPlan
    private var context: AppNavigation.LessonsNavigation {
        get { contextBinding.wrappedValue }
        nonmutating set { contextBinding.wrappedValue = newValue }
    }
    private var contextBinding: Binding<AppNavigation.LessonsNavigation> { externalContext ?? $internalContext }
    private var externalContext: Binding<AppNavigation.LessonsNavigation>?
    @State
    private var internalContext: AppNavigation.LessonsNavigation = .none

    init(lessonPlan: LessonPlan, context: Binding<AppNavigation.LessonsNavigation>?) {
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
    private var isRescheduling = false // TODO: move to AppNavigation
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
            .offset(x: 40, y: -64)

            VStack(spacing: 0) {
                TitleContentView(title: title) {
                    VStack(alignment: .leading, spacing: .spacingExtraLarge) {
                        Pill(lessonPlan: lessonPlan)
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
                            .frame(maxWidth: .spacingMax)
                            .padding(.horizontal, .spacingMedium)
                        }
                    }
                }

                floatingButton
            }
        }
        .testable(self)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: moreButton)
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

    @ViewBuilder
    private var moreButton: some View {
        if let actions = actions.nilIfEmpty {
            MoreButton(actions)
        }
    }

    @ArrayBuilder<MoreButton.Button>
    private var actions: [MoreButton.Button] {
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule", action: action)
        }
        if let action = showCancelLessonPlanFormAction {
            .init(title: "Cancel Plan", action: action)
        }
    }

    @ViewBuilder
    private var floatingButton: some View {
        if let action = chooseTutorAction {
            FloatingActionMenu([.init(title: "Choose Tutor", isPrimary: true, action: action)])
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
