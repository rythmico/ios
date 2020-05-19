import UIKit
import Combine
import UserNotifications
import Sugar

enum PushNotificationAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}

class PushNotificationAuthorizationManagerBase: ObservableObject {
    @Published
    var status: PushNotificationAuthorizationStatus = .notDetermined

    func refreshAuthorizationStatus() {}
    func requestAuthorization(errorHandler: @escaping Handler<Error>) {}
}

final class PushNotificationAuthorizationManager: PushNotificationAuthorizationManagerBase {
    private let application: UIApplication
    private let center: UNUserNotificationCenter

    init(application: UIApplication, center: UNUserNotificationCenter) {
        self.application = application
        self.center = center
        super.init()
        refreshAuthorizationStatus()
    }

    override func refreshAuthorizationStatus() {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.status = .notDetermined
                case .denied:
                    self.status = .denied
                case .authorized, .provisional:
                    self.status = .authorized
                @unknown default:
                    self.status = .notDetermined
                }
            }
        }
    }

    override func requestAuthorization(errorHandler: @escaping Handler<Error>) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorHandler(error)
                } else {
                    if granted {
                        self.status = .authorized
                        self.application.registerForRemoteNotifications()
                    } else {
                        self.status = .denied
                    }
                }
            }
        }
    }
}
