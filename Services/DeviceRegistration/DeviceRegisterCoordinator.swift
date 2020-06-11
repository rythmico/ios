import Foundation

final class DeviceRegisterCoordinator {
    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let deviceTokenProvider: DeviceTokenProvider
    private let service: DeviceRegisterServiceProtocol

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        deviceTokenProvider: DeviceTokenProvider,
        service: DeviceRegisterServiceProtocol
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.deviceTokenProvider = deviceTokenProvider
        self.service = service
    }

    func registerDevice() {
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.deviceTokenProvider.deviceToken { result, _ in
                    if let deviceToken = result?.token {
                        self.service.registerDevice(accessToken: accessToken, deviceToken: deviceToken)
                    }
                }
            case .failure:
                break
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
