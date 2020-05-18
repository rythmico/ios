import SwiftUI
import Sugar

struct RequestLessonPlanConfirmationView: View, TestableView {
    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    private let lessonPlan: LessonPlan
    private let notificationsAuthorizationManager: PushNotificationAuthorizationManagerProtocol

    init(
        lessonPlan: LessonPlan,
        notificationsAuthorizationManager: PushNotificationAuthorizationManagerProtocol
    ) {
        self.lessonPlan = lessonPlan
        self.notificationsAuthorizationManager = notificationsAuthorizationManager
    }

    var title: String {
        lessonPlan.instrument.name + " Lessons Request Submitted!"
    }

    var subtitle: String {
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta odio dolor, eget sodales turpis mollis semper."
    }

    @State
    var shouldShowEnableNotificationsButton = true

    @State
    var errorMessage: String?

    var didAppear: Handler<Self>?
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: .spacingUnit * 8) {
                VStack(spacing: .spacingLarge) {
                    lessonPlan.instrument.icon
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.rythmicoForeground)

                    VStack(spacing: .spacingSmall) {
                        Text(title)
                            .multilineTextAlignment(.center)
                            .rythmicoFont(.largeTitle)
                            .foregroundColor(.rythmicoForeground)
                            .padding(.horizontal, .spacingUnit * 11)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(subtitle)
                            .multilineTextAlignment(.center)
                            .rythmicoFont(.body)
                            .foregroundColor(.rythmicoGray90)
                            .padding(.horizontal, .spacingLarge)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                if shouldShowEnableNotificationsButton {
                    Button("Enable Push Notifications", action: enablePushNotifications)
                        .secondaryStyle()
                        .frame(maxWidth: 236)
                        .frame(height: 40)
                        .transition(
                            AnyTransition.opacity.combined(with: .move(edge: .bottom))
                        )
                }
            }

            Spacer()

            FloatingView {
                Button("Continue", action: doContinue).primaryStyle()
            }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: shouldShowEnableNotificationsButton)
        .alert(item: $errorMessage) { Alert(title: Text("An error ocurred"), message: Text($0)) }
        .onAppear { self.didAppear?(self) }
        .onAppear { self.fetchNotificationAuthorizationStatus() }
    }

    private func fetchNotificationAuthorizationStatus() {
        notificationsAuthorizationManager.getAuthorizationStatus { status in
            self.shouldShowEnableNotificationsButton = status == .notDetermined
        }
    }

    func enablePushNotifications() {
        notificationsAuthorizationManager.requestAuthorization { result in
            switch result {
            case .success:
                self.shouldShowEnableNotificationsButton = false
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func doContinue() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct RequestLessonPlanConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = PushNotificationAuthorizationManagerStub(
            authorizationStatus: .authorized,
            requestAuthorizationResult: .success(true)
        )
        return RequestLessonPlanConfirmationView(
            lessonPlan: .stub,
            notificationsAuthorizationManager: manager
        )
//        .previewDevices()
    }
}
