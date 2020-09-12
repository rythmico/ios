import UIKit

extension AppDelegate {
    func configureLifecycleEvents() {
        onNotification(UIApplication.didEnterBackgroundNotification, perform: App.didEnterBackground)
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
