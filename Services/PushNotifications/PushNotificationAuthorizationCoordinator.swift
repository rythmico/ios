import UIKit
import Combine
import Sugar

final class PushNotificationAuthorizationCoordinator: ObservableObject {
    enum Status {
        case notDetermined
        case authorizing
        case failed(Error)
        case denied
        case authorized

        var isDetermined: Bool {
            switch self {
            case .notDetermined, .authorizing, .failed:
                return false
            case .denied, .authorized:
                return true
            }
        }
    }

    @Published
    private(set) var status: Status = .notDetermined

    private let center: UNUserNotificationCenterProtocol
    private let registerService: PushNotificationRegisterServiceProtocol
    private let queue: DispatchQueue?

    init(
        center: UNUserNotificationCenterProtocol,
        registerService: PushNotificationRegisterServiceProtocol,
        queue: DispatchQueue?
    ) {
        self.center = center
        self.registerService = registerService
        self.queue = queue
        refreshAuthorizationStatus()
    }

    func refreshAuthorizationStatus() {
        center.getNotificationSettings { settings in
            self.queue.asyncOrImmediate {
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

    func requestAuthorization() {
        status = .authorizing
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            self.queue.asyncOrImmediate {
                if let error = error {
                    self.status = .failed(error)
                } else {
                    if granted {
                        self.status = .authorized
                        self.registerService.registerForRemoteNotifications()
                    } else {
                        self.status = .denied
                    }
                }
            }
        }
    }

    func dismissFailure() {
        if status.isFailed {
            status = .notDetermined
        }
    }
}
