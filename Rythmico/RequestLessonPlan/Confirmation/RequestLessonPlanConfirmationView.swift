import SwiftUI
import Sugar

struct RequestLessonPlanConfirmationView: View, TestableView {
    @Environment(\.presentationMode)
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

    func dismissError() {
        notificationAuthorizationCoordinator.dismissFailure()
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: .spacingUnit * 8) {
                        VStack(spacing: 0) {
                            VStack(spacing: .spacingLarge) {
                                VectorImage(asset: lessonPlan.instrument.icon, resizeable: true)
                                    .frame(width: 48, height: 48)
                                    .accentColor(.rythmicoForeground)

                                VStack(spacing: .spacingSmall) {
                                    Text(title)
                                        .multilineTextAlignment(.center)
                                        .rythmicoFont(.largeTitle)
                                        .foregroundColor(.rythmicoForeground)
                                        .minimumScaleFactor(0.8)

                                    Text(subtitle)
                                        .multilineTextAlignment(.center)
                                        .rythmicoFont(.body)
                                        .foregroundColor(.rythmicoGray90)
                                }
                            }
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
        presentationMode.wrappedValue.dismiss()
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
        return RequestLessonPlanConfirmationView(lessonPlan: .pendingJackGuitarPlanStub)
            .previewDevices()
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
