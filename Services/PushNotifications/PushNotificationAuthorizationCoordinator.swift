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

        var isAuthorizing: Bool {
            guard case .authorizing = self else { return false }
            return true
        }

        var failedValue: Error? {
            guard case .failed(let error) = self else { return nil }
            return error
        }

        var isFailed: Bool {
            failedValue != nil
        }
    }

    @Published
    private(set) var status: Status = .notDetermined

    private let center: UNUserNotificationCenterProtocol
    private let registerService: PushNotificationRegisterServiceProtocol

    init(
        center: UNUserNotificationCenterProtocol,
        registerService: PushNotificationRegisterServiceProtocol
    ) {
        self.center = center
        self.registerService = registerService
        refreshAuthorizationStatus()
    }

    func refreshAuthorizationStatus() {
        center.getNotificationSettings { settings in
            DispatchQueue.main.immediateOrAsync {
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
            DispatchQueue.main.immediateOrAsync {
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
