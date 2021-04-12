import SwiftUI
import FoundationSugar

struct LessonPlanConfirmationView: View, TestableView {
    @ObservedObject
    private var calendarSyncCoordinator = Current.calendarSyncCoordinator

    var lessonPlan: LessonPlan

    var title: String {
        switch lessonPlan.status {
        case .scheduled:
            return ["\(lessonPlan.instrument.assimilatedName) Lessons", "Confirmed!"].joined(separator: "\n")
        default:
            return ["\(lessonPlan.instrument.assimilatedName) Lessons", "Request Submitted!"].joined(separator: "\n")
        }
    }

    var subtitle: String? {
        switch lessonPlan.status {
        case .scheduled:
            return nil
        default:
            return "Potential tutors have received your request and will submit applications for your consideration."
        }
    }

    @ViewBuilder
    var additionalContent: some View {
        switch lessonPlan.status {
        case .scheduled(_, let tutor):
            LessonPlanConfirmationDetailsView(lessonPlan: lessonPlan, tutor: tutor)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    var addToCalendarButton: some View {
        switch lessonPlan.status {
        case .scheduled:
            if let action = calendarSyncCoordinator.enableCalendarSyncAction {
                ZStack {
                    Button("Add to Calendar", action: action)
                        .tertiaryStyle(expansive: false)
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
                            Image(
                                uiImage: lessonPlan.instrument.icon.image
                                    // TODO: check if SVG still blurry without resize in SwiftUI 3.
                                    .resized(to: .init(width: 48, height: 48))
                            )
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.rythmicoForeground)

                            VStack(spacing: .spacingSmall) {
                                Text(title)
                                    .foregroundColor(.rythmicoForeground)
                                    .rythmicoFont(.largeTitle)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.8)
                                if let subtitle = subtitle {
                                    Text(subtitle)
                                        .foregroundColor(.rythmicoGray90)
                                        .rythmicoFont(.body)
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
                Button("Continue", action: doContinue)
                    .primaryStyle()
                    .disabled(calendarSyncCoordinator.isSyncingCalendar)
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: calendarSyncCoordinator.isSyncingCalendar)
        .testable(self)
    }

    func doContinue() {
        Current.pushNotificationAuthorizationCoordinator.requestAuthorization()
        Current.state.lessonsContext = .none
    }
}

#if DEBUG
struct LessonPlanConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanConfirmationView(lessonPlan: .pendingJackGuitarPlanStub)
//        LessonPlanConfirmationView(lessonPlan: .scheduledJackGuitarPlanStub)
    }
}
#endif
