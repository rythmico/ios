import FoundationEncore
import Combine

final class AnalyticsCoordinator {
    private let service: AnalyticsServiceProtocol
    private let userCredentialProvider: UserCredentialProviderBase
    private let accessibilitySettings: AccessibilitySettings
    private let notificationAuthCoordinator: PushNotificationAuthorizationCoordinator
    private let calendarSyncCoordinator: CalendarSyncCoordinator

    private var cancellables: [AnyCancellable] = []

    init(
        service: AnalyticsServiceProtocol,
        userCredentialProvider: UserCredentialProviderBase,
        accessibilitySettings: AccessibilitySettings,
        notificationAuthCoordinator: PushNotificationAuthorizationCoordinator,
        calendarSyncCoordinator: CalendarSyncCoordinator
    ) {
        self.service = service
        self.userCredentialProvider = userCredentialProvider
        self.accessibilitySettings = accessibilitySettings
        self.notificationAuthCoordinator = notificationAuthCoordinator
        self.calendarSyncCoordinator = calendarSyncCoordinator

        userCredentialProvider.$userCredential
            .mapToVoid()
            .sink(receiveValue: updateOrResetUserProfile)
            .store(in: &cancellables)

        notificationAuthCoordinator.$status
            .mapToVoid()
            .sink(receiveValue: updateOrResetUserProfile)
            .store(in: &cancellables)

        calendarSyncCoordinator.objectWillChange
            .delay(for: 0, scheduler: DispatchQueue.main)
            .sink(receiveValue: updateOrResetUserProfile)
            .store(in: &cancellables)
    }

    private func updateOrResetUserProfile() {
        if let credential = userCredentialProvider.userCredential {
            service.identify(
                AnalyticsUserProfile(
                    id: credential.userID,
                    accessibilitySettings: accessibilitySettings,
                    pushNotificationsAuthStatus: notificationAuthCoordinator.status,
                    isCalendarSyncEnabled: calendarSyncCoordinator.isCalendarSyncEnabled
                )
            )
        } else {
            service.reset()
        }
    }

    func updateUserProperties(_ props: AnalyticsEvent.Props) {
        service.update(props)
    }

    func track(_ event: AnalyticsEvent) {
        service.track(event)
    }
}
