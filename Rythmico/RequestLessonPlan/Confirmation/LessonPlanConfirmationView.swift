import SwiftUI
import Sugar

struct LessonPlanConfirmationView: View, TestableView {
    @StateObject
    private var notificationAuthorizationCoordinator = Current.pushNotificationAuthorizationCoordinator

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

    var enablePushNotificationsButtonAction: Action? {
        notificationAuthorizationCoordinator.status.isDetermined
            ? nil
            : notificationAuthorizationCoordinator.requestAuthorization
    }

    var errorMessage: String? { notificationAuthorizationCoordinator.status.failedValue?.localizedDescription }

    func dismissError() {
        notificationAuthorizationCoordinator.dismissFailure()
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
                                    .multilineTextAlignment(.center)
                                    .rythmicoFont(.largeTitle)
                                    .foregroundColor(.rythmicoForeground)
                                    .minimumScaleFactor(0.8)
                                if let subtitle = subtitle {
                                    Text(subtitle)
                                        .multilineTextAlignment(.center)
                                        .rythmicoFont(.body)
                                        .foregroundColor(.rythmicoGray90)
                                }
                            }

                            additionalContent
                        }

                        enablePushNotificationsButtonAction.map {
                            Button("Enable Push Notifications", action: $0)
                                .tertiaryStyle(expansive: false)
                                .transition(
                                    AnyTransition.opacity.combined(with: .move(edge: .bottom))
                                )
                        }
                    }
                    .padding(.horizontal, .spacingMedium)
                    .padding(.vertical, .spacingLarge)
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }

            FloatingView {
                Button("Continue", action: doContinue).primaryStyle()
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: enablePushNotificationsButtonAction != nil)
        .alert(error: errorMessage, dismiss: dismissError)
        .testable(self)
        .onAppear(perform: notificationAuthorizationCoordinator.refreshAuthorizationStatus)
    }

    func doContinue() {
        Current.state.lessonsContext = .none
    }
}

#if DEBUG
struct RequestLessonPlanConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
//            initialStatus: .authorized,
            requestResult: (true, nil)
//            requestResult: (false, nil)
//            requestResult: (false, "Error")
        )
        return Group {
            LessonPlanConfirmationView(lessonPlan: .pendingJackGuitarPlanStub)
            LessonPlanConfirmationView(lessonPlan: .scheduledJackGuitarPlanStub)
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
