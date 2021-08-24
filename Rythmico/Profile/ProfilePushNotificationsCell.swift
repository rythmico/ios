import SwiftUIEncore

struct ProfilePushNotificationsCell: View {
    @ObservedObject
    private var coordinator = Current.pushNotificationAuthorizationCoordinator

    var body: some View {
        ProfileCell("Push Notifications", disclosure: disclosure, action: goToSettingsAction, accessory: toggleButton)
            .multiModal {
                $0.alert(error: error, dismiss: dismissError)
            }
    }

    var disclosure: Bool {
        goToSettingsAction != nil
    }

    var goToSettingsAction: Action? {
        enableAction == nil ? { Current.urlOpener.openSettings() } : nil
    }

    @ViewBuilder
    private func toggleButton() -> some View {
        if let action = enableAction {
            Toggle("", isOn: .constant(coordinator.status.isAuthorizing))
                .labelsHidden()
                .onTapGesture(perform: action)
        }
    }

    var enableAction: Action? {
        coordinator.status.isDetermined ? nil : coordinator.requestAuthorization
    }

    var error: Error? {
        coordinator.status.failedValue
    }

    func dismissError() {
        coordinator.dismissFailure()
    }
}
