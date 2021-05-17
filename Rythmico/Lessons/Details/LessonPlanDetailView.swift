import SwiftUI
import ComposableNavigator
import MultiModal
import FoundationSugar

struct LessonPlanDetailScreen: Screen {
    let lessonPlan: LessonPlan
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanDetailScreen) in
                    LessonPlanDetailView(lessonPlan: screen.lessonPlan)
                },
                nesting: {
                    LessonPlanCancellationScreen.Builder()
                    LessonPlanApplicationsScreen.Builder()
                    LessonPlanTutorDetailScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanDetailView: View, TestableView {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var title: String {
        [lessonPlan.student.name.firstWord, "\(lessonPlan.instrument.assimilatedName) Lessons"]
            .compact()
            .joined(separator: " - ")
    }

    var lessonPlan: LessonPlan
    var lessonPlanReschedulingView: LessonReschedulingView? { !lessonPlan.status.isCancelled ? .reschedulingView(lessonPlan: lessonPlan) : nil }

    var chooseTutorAction: Action? {
        LessonPlanApplicationsScreen(lessonPlan: lessonPlan).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
    }

    @State
    private var isRescheduling = false // TODO: move to AppNavigation
    var showRescheduleAlertAction: Action? {
        lessonPlanReschedulingView != nil
            ? { isRescheduling = true }
            : nil
    }

    var showCancelLessonPlanFormAction: Action? {
        LessonPlanCancellationScreen(lessonPlan: lessonPlan).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            TitleContentView(title: title) {
                VStack(alignment: .leading, spacing: .spacingExtraLarge) {
                    Pill(lessonPlan: lessonPlan, backgroundColor: .rythmicoBackground)
                        .padding(.horizontal, .spacingMedium)

                    ScrollView {
                        VStack(alignment: .leading, spacing: .spacingMedium) {
                            planDetailsSection
                            tutorSection
                            paymentSection
                        }
                        .foregroundColor(.rythmicoGray90)
                        .frame(maxWidth: .spacingMax)
                        .padding([.horizontal, .bottom], .spacingMedium)
                    }
                }
            }
            .watermark(lessonPlan.instrument.icon.image, offset: .init(width: 40, height: -64))

            floatingButton
        }
        .backgroundColor(.rythmicoBackground)
        .testable(self)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: moreButton)
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lessonPlan: lessonPlan) }
        }
    }

    @ViewBuilder
    private var planDetailsSection: some View {
        SectionHeaderView(title: "Plan Details")
        LessonPlanScheduleView(lessonPlan: lessonPlan)
        AddressLabel(address: lessonPlan.address)
    }

    @ViewBuilder
    private var tutorSection: some View {
        SectionHeaderView(title: "Tutor")
        switch lessonPlan.status {
        case .pending, .reviewing, .cancelled(_, .none, _):
            LessonPlanTutorStatusView(status: lessonPlan.status, summarized: false)
            if lessonPlan.status.isPending {
                InfoBanner(text: "Potential tutors have received your request and will submit applications for your consideration.")
            }
        case .active(_, let tutor), .cancelled(_, let tutor?, _):
            TutorCell(lessonPlan: lessonPlan, tutor: tutor)
        }
    }

    @ViewBuilder
    private var paymentSection: some View {
        switch lessonPlan.status {
        case .active:
            SectionHeaderView(title: "Payment")
            LessonPlanPriceView(
                price: Price(amount: Decimal(lessonPlan.schedule.duration.rawValue), currency: .GBP),
                showTermsOfService: false
            )
        case .pending, .reviewing, .cancelled:
            EmptyView()
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
            .init(title: "Reschedule Plan", action: action)
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
        Group {
            LessonPlanDetailView(lessonPlan: .pendingJackGuitarPlanStub)
            LessonPlanDetailView(lessonPlan: .activeJackGuitarPlanStub)
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
