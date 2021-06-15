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
                    LessonPlanPausingScreen.Builder()
                    LessonPlanResumingScreen.Builder()
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
    var lessonPlanReschedulingView: LessonReschedulingView? { !lessonPlan.status.isCancelled && !lessonPlan.status.isPaused ? .reschedulingView(lessonPlan: lessonPlan) : nil }

    var chooseTutorAction: Action? {
        LessonPlanApplicationsScreen(lessonPlan: lessonPlan).map { screen in
            {
                navigator.go(to: screen, on: currentScreen)
                Current.analytics.track(
                    .chooseTutorScreenView(
                        lessonPlan: screen.lessonPlan,
                        applications: screen.applications,
                        origin: .lessonsTabDetail
                    )
                )
            }
        }
    }

    @State
    private var isRescheduling = false // TODO: move to AppNavigation
    var showRescheduleAlertAction: Action? {
        lessonPlanReschedulingView != nil
            ? { isRescheduling = true }
            : nil
    }

    var showPauseLessonPlanFormAction: Action? {
        LessonPlanPausingScreen(lessonPlan: lessonPlan).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
    }

    var showResumeLessonPlanFormAction: Action? {
        LessonPlanResumingScreen(lessonPlan: lessonPlan).map { screen in
            { navigator.go(to: screen, on: currentScreen) }
        }
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
        .navigationBarItems(trailing: optionsButton)
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
        case .active(_, let tutor), .paused(_, let tutor, _), .cancelled(_, let tutor?, _):
            TutorCell(lessonPlan: lessonPlan, tutor: tutor)
        }
    }

    @ViewBuilder
    private var paymentSection: some View {
        switch lessonPlan.status {
        case .active, .paused:
            SectionHeaderView(title: "Payment")
            LessonPlanPriceView(
                price: Price(amount: Decimal(lessonPlan.schedule.duration.rawValue), currency: .GBP), // TODO: consume `bookingInfo.pricePerLesson` property instead.
                showTermsOfService: false
            )
        case .pending, .reviewing, .cancelled: // TODO: consume `bookingInfo.pricePerLesson` property instead (for cancelled).
            EmptyView()
        }
    }

    @ViewBuilder
    private var optionsButton: some View {
        if let actions = actions.nilIfEmpty {
            OptionsButton(actions)
        }
    }

    @ArrayBuilder<ContextMenuButton>
    private var actions: [ContextMenuButton] {
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule Plan", icon: Asset.Icon.Action.reschedule, action: action)
        }
        if let action = showPauseLessonPlanFormAction {
            .init(title: "Pause Plan", icon: Asset.Icon.Action.pause, action: action)
        }
        if let action = showResumeLessonPlanFormAction {
            .init(title: "Resume Plan", icon: Asset.Icon.Action.resume, action: action)
        }
        if let action = showCancelLessonPlanFormAction {
            .init(title: "Cancel Plan", icon: Asset.Icon.Action.cancel, action: action)
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
