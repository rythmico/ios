import UIKit
import UserNotifications
import Sugar

enum PushNotificationAuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}

protocol PushNotificationAuthorizationManagerProtocol {
    typealias GetCompletionHandler = (PushNotificationAuthorizationStatus) -> Void
    func getAuthorizationStatus(completion: @escaping GetCompletionHandler)

    typealias RequestCompletionHandler = SimpleResultHandler<Bool>
    func requestAuthorization(completion: @escaping RequestCompletionHandler)
}

final class PushNotificationAuthorizationManager: PushNotificationAuthorizationManagerProtocol {
    private let application: UIApplication
    private let center: UNUserNotificationCenter

    init(application: UIApplication, center: UNUserNotificationCenter) {
        self.application = application
        self.center = center
    }

    func getAuthorizationStatus(completion: @escaping GetCompletionHandler) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                completion(.notDetermined)
            case .denied:
                completion(.denied)
            case .authorized, .provisional:
                completion(.authorized)
            @unknown default:
                completion(.notDetermined)
            }
        }
    }

    func requestAuthorization(completion: @escaping RequestCompletionHandler) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    if granted {
                        self.application.registerForRemoteNotifications()
                    }
                    completion(.success(granted))
                }
            }
        }
    }
}
