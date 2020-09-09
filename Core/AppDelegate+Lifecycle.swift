import UIKit

extension AppDelegate {
    func configureLifecycleEvents() {
        onNotification(UIApplication.willResignActiveNotification, perform: App.willResignActive)
    }

    private func onNotification(_ name: Notification.Name, perform action: @escaping () -> Void) {
        let cancellable = NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: .main,
            using: { _ in action() }
        )
        notificationCenterCancellables.append(cancellable)
    }
}
