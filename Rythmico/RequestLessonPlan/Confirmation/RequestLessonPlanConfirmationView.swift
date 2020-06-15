import SwiftUI
import Sugar

struct RequestLessonPlanConfirmationView: View, TestableView {
    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    @ObservedObject
    private var notificationAuthorizationCoordinator = Current.pushNotificationAuthorizationCoordinator

    private let lessonPlan: LessonPlan

    init(lessonPlan: LessonPlan) {
        self.lessonPlan = lessonPlan
    }

    var title: String {
        ["\(lessonPlan.instrument.name) Lessons", "Request Submitted!"].joined(separator: "\n")
    }

    var subtitle: String {
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta odio dolor, eget sodales turpis mollis semper."
    }

    var enablePushNotificationsButtonAction: Action? {
        notificationAuthorizationCoordinator.status.isDetermined
            ? nil
            : notificationAuthorizationCoordinator.requestAuthorization
    }

    var errorMessage: String? { notificationAuthorizationCoordinator.status.failedValue?.localizedDescription }

    var didAppear: Handler<Self>?
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: .spacingUnit * 8) {
                        VStack(spacing: 0) {
                            VStack(spacing: .spacingLarge) {
                                self.lessonPlan.instrument.largeIcon
                                    .renderingMode(.template)
                                    .foregroundColor(.rythmicoForeground)

                                VStack(spacing: .spacingSmall) {
                                    Text(self.title)
                                        .multilineTextAlignment(.center)
                                        .rythmicoFont(.largeTitle)
                                        .foregroundColor(.rythmicoForeground)
                                        .minimumScaleFactor(0.8)

                                    Text(self.subtitle)
                                        .multilineTextAlignment(.center)
                                        .rythmicoFont(.body)
                                        .foregroundColor(.rythmicoGray90)
                                }
                            }
                        }

                        self.enablePushNotificationsButtonAction.map {
                            Button("Enable Push Notifications", action: $0)
                                .secondaryStyle()
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
        .alert(error: self.errorMessage, dismiss: notificationAuthorizationCoordinator.dismissFailure)
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: notificationAuthorizationCoordinator.refreshAuthorizationStatus)
    }

    func doContinue() {
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct RequestLessonPlanConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()

        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: .notDetermined,
//                authorizationStatus: .authorized,
                authorizationRequestResult: (true, nil)
//                authorizationRequestResult: (false, nil)
//                authorizationRequestResult: (false, "Error")
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )

        return RequestLessonPlanConfirmationView(lessonPlan: .jackGuitarPlanStub)
            .previewDevices()
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
