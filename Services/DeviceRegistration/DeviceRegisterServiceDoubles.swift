import Foundation

final class DeviceRegisterServiceSpy: DeviceRegisterServiceProtocol {
    var registerCount = 0

    func registerDevice(accessToken: String, deviceToken: String) {
        registerCount += 1
    }
}

final class DeviceRegisterServiceDummy: DeviceRegisterServiceProtocol {
    func registerDevice(accessToken: String, deviceToken: String) {
        // NO-OP
    }
}
