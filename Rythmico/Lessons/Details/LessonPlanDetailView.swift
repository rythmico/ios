import SwiftUISugar
import ComposableNavigator

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
            .compacted()
            .joined(separator: " - ")
    }

    let lessonPlan: LessonPlan

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            TitleContentView(title) { padding in
                VStack(alignment: .leading, spacing: .grid(5)) {
                    Pill(lessonPlan: lessonPlan).padding(padding)
                    ScrollView {
                        VStack(spacing: .grid(4)) {
                            SectionHeaderContentView("Plan Details", style: .box) {
                                VStack(alignment: .leading, spacing: .grid(2)) {
                                    LessonPlanScheduleView(schedule: lessonPlan.schedule)
                                    AddressLabel(address: lessonPlan.address)
                                }
                            }
                            SectionHeaderContentView("Tutor", style: .box) {
                                LessonPlanDetailTutorStatusView(lessonPlan: lessonPlan)
                            }
                            paymentSection
                        }
                        .foregroundColor(.rythmico.foreground)
                        .frame(maxWidth: .grid(.max))
                        .padding([.horizontal, .bottom], .grid(4))
                    }
                }
            }
            .watermark(
                lessonPlan.instrument.icon.image,
                color: .rythmico.picoteeBlue,
                offset: .init(width: -8, height: -45)
            )

            floatingButton
        }
        .backgroundColor(.rythmico.background)
        .testable(self)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: LessonPlanOptionsButton(lessonPlan: lessonPlan, size: .medium))
    }

    @ViewBuilder
    private var paymentSection: some View {
        switch lessonPlan.status {
        case .active, .paused:
            LessonPlanPriceView(
                // TODO: consume `bookingInfo.pricePerLesson` property instead.
                price: Price(
                    amount: PreciseDecimal(lessonPlan.schedule.duration.rawValue),
                    currency: .GBP
                ),
                showTermsOfService: false
            )
        case .pending, .reviewing, .cancelled: // TODO: consume `bookingInfo.pricePerLesson` property instead (for cancelled).
            EmptyView()
        }
    }

    @ViewBuilder
    private var floatingButton: some View {
        if let action = chooseTutorAction {
            FloatingActionMenu([.init(title: "Choose Tutor", isPrimary: true, action: action)])
        }
    }

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
}

#if DEBUG
struct LessonPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                LessonPlanDetailView(lessonPlan: .pendingJesseDrumsPlanStub)
            }
            NavigationView {
                LessonPlanDetailView(lessonPlan: .activeJackGuitarPlanStub)
            }
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
