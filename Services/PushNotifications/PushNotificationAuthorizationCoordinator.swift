import UIKit
import Combine
import FoundationSugar

final class PushNotificationAuthorizationCoordinator: ObservableObject {
    enum Status {
        case notDetermined
        case authorizing
        case failed(Error)
        case denied
        case authorized
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
        center.getNotificationSettings { [self] settings in
            DispatchQueue.main.nowOrAsync {
                switch settings.authorizationStatus {
                case .notDetermined:
                    status = .notDetermined
                case .denied:
                    status = .denied
                case .authorized, .provisional, .ephemeral:
                    status = .authorized
                @unknown default:
                    status = .notDetermined
                }
            }
        }
    }

    func requestAuthorization() {
        guard !status.isDetermined else {
            return
        }
        status = .authorizing
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [self] granted, error in
            DispatchQueue.main.nowOrAsync {
                if let error = error {
                    status = .failed(error)
                } else {
                    if granted {
                        status = .authorized
                        registerService.registerForRemoteNotifications()
                    } else {
                        status = .denied
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
