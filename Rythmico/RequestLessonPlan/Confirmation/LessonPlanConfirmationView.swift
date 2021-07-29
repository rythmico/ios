import SwiftUISugar

struct LessonPlanConfirmationView: View, TestableView {
    @ObservedObject
    private var calendarSyncCoordinator = Current.calendarSyncCoordinator
    @Environment(\.navigator)
    private var navigator

    var lessonPlan: LessonPlan

    @ScaledMetric(relativeTo: .largeTitle)
    private var iconWidth: CGFloat = .grid(18)

    var title: String {
        switch lessonPlan.status {
        case .active:
            return ["\(lessonPlan.instrument.assimilatedName) Lessons", "Confirmed!"].joined(separator: "\n")
        default:
            return ["\(lessonPlan.instrument.assimilatedName) Lessons", "Request Submitted!"].joined(separator: "\n")
        }
    }

    var subtitle: String? {
        switch lessonPlan.status {
        case .active:
            return nil
        default:
            return "Potential tutors have received your request and will submit applications for your consideration."
        }
    }

    @ViewBuilder
    var additionalContent: some View {
        if lessonPlan.status.isActive, let tutor = lessonPlan.bookingInfo?.tutor {
            LessonPlanConfirmationDetailsView(lessonPlan: lessonPlan, tutor: tutor)
        }
    }

    @ViewBuilder
    var addToCalendarButton: some View {
        switch lessonPlan.status {
        case .active:
            if let action = calendarSyncCoordinator.enableCalendarSyncAction {
                ZStack {
                    RythmicoButton("Add to Calendar", style: RythmicoButtonStyle.tertiary(expansive: false), action: action)
                        .opacity(calendarSyncCoordinator.isSyncingCalendar ? 0 : 1)
                    if calendarSyncCoordinator.isSyncingCalendar {
                        ActivityIndicator()
                    }
                }
                .transition(.opacity)
            }
        default:
            EmptyView()
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: .grid(8)) {
                        VStack(spacing: .grid(6)) {
                            Image(uiImage: lessonPlan.instrument.icon.image.resized(width: iconWidth))
                                .renderingMode(.template)
                                .foregroundColor(.rythmico.foreground)

                            VStack(spacing: .grid(4)) {
                                Text(title)
                                    .foregroundColor(.rythmico.foreground)
                                    .rythmicoTextStyle(.largeTitle)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.8)
                                if let subtitle = subtitle {
                                    Text(subtitle)
                                        .foregroundColor(.rythmico.gray90)
                                        .rythmicoTextStyle(.body)
                                        .multilineTextAlignment(.center)
                                }
                            }

                            additionalContent
                        }

                        addToCalendarButton
                    }
                    .padding(.horizontal, .grid(5))
                    .padding(.vertical, .grid(6))
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }

            FloatingView {
                RythmicoButton("Continue", style: RythmicoButtonStyle.primary(), action: doContinue)
                    .disabled(calendarSyncCoordinator.isSyncingCalendar)
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: calendarSyncCoordinator.isSyncingCalendar)
        .testable(self)
    }

    func doContinue() {
        Current.pushNotificationAuthorizationCoordinator.requestAuthorization()
        // Either, depending on which tab we're on.
        navigator.goBack(to: LessonPlansScreen())
        navigator.goBack(to: LessonsScreen())
    }
}

#if DEBUG
struct LessonPlanConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanConfirmationView(lessonPlan: .pendingJackGuitarPlanStub)
//        LessonPlanConfirmationView(lessonPlan: .activeJackGuitarPlanStub)
    }
}
#endif
