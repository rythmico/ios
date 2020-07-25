import Foundation

final class DeviceRegisterCoordinator {
    typealias APICoordinator = APIActivityCoordinator<AddDeviceRequest>

    private let deviceTokenProvider: DeviceTokenProvider
    private let apiCoordinator: APICoordinator

    init(deviceTokenProvider: DeviceTokenProvider, apiCoordinator: APICoordinator) {
        self.deviceTokenProvider = deviceTokenProvider
        self.apiCoordinator = apiCoordinator
    }

    func registerDevice() {
        deviceTokenProvider.deviceToken { result, _ in
            if let deviceToken = result?.token {
                self.apiCoordinator.run(with: .init(body: .init(token: deviceToken)))
            }
        }
    }
}

final class DeviceUnregisterCoordinator {
    private let deviceTokenDeleter: DeviceTokenDeleter

    init(deviceTokenDeleter: DeviceTokenDeleter) {
        self.deviceTokenDeleter = deviceTokenDeleter
    }

    func unregisterDevice() {
        deviceTokenDeleter.deleteID { _ in }
    }
}
