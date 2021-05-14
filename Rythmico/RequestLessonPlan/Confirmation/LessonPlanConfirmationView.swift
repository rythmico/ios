import SwiftUI
import FoundationSugar

struct LessonPlanConfirmationView: View, TestableView {
    @ObservedObject
    private var calendarSyncCoordinator = Current.calendarSyncCoordinator
    @Environment(\.navigator)
    private var navigator

    var lessonPlan: LessonPlan

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
        switch lessonPlan.status {
        case .active(_, let tutor):
            LessonPlanConfirmationDetailsView(lessonPlan: lessonPlan, tutor: tutor)
        default:
            EmptyView()
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
                    VStack(spacing: .spacingUnit * 8) {
                        VStack(spacing: .spacingLarge) {
                            Image(uiImage: lessonPlan.instrument.icon.image)
                                .foregroundColor(.rythmicoForeground)

                            VStack(spacing: .spacingSmall) {
                                Text(title)
                                    .foregroundColor(.rythmicoForeground)
                                    .rythmicoTextStyle(.largeTitle)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.8)
                                if let subtitle = subtitle {
                                    Text(subtitle)
                                        .foregroundColor(.rythmicoGray90)
                                        .rythmicoTextStyle(.body)
                                        .multilineTextAlignment(.center)
                                }
                            }

                            additionalContent
                        }

                        addToCalendarButton
                    }
                    .padding(.horizontal, .spacingMedium)
                    .padding(.vertical, .spacingLarge)
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
        navigator.goBack(to: .root)
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
