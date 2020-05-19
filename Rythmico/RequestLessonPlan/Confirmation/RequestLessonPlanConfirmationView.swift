import SwiftUI
import Sugar

struct RequestLessonPlanConfirmationView: View, TestableView {
    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    private let lessonPlan: LessonPlan
    @ObservedObject
    private var notificationsAuthorizationManager: PushNotificationAuthorizationManagerBase

    init(
        lessonPlan: LessonPlan,
        notificationsAuthorizationManager: PushNotificationAuthorizationManagerBase
    ) {
        self.lessonPlan = lessonPlan
        self.notificationsAuthorizationManager = notificationsAuthorizationManager
    }

    var title: String {
        ["\(lessonPlan.instrument.name) Lessons", "Request Submitted!"].joined(separator: "\n")
    }

    var subtitle: String {
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta odio dolor, eget sodales turpis mollis semper."
    }

    var enablePushNotificationsButtonAction: Action? {
        guard notificationsAuthorizationManager.status == .notDetermined else {
            return nil
        }
        return {
            self.notificationsAuthorizationManager.requestAuthorization { error in
                self.errorMessage = error.localizedDescription
            }
        }
    }

    @State
    var errorMessage: String?

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
        .alert(item: $errorMessage) { Alert(title: Text("An error ocurred"), message: Text($0)) }
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: notificationsAuthorizationManager.refreshAuthorizationStatus)
    }

    func doContinue() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct RequestLessonPlanConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = PushNotificationAuthorizationManagerStub(
//            status: .authorized,
            status: .notDetermined,
            requestAuthorizationResult: .success(true)
        )
        return RequestLessonPlanConfirmationView(
            lessonPlan: .stub,
            notificationsAuthorizationManager: manager
        )
        .previewDevices()
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
