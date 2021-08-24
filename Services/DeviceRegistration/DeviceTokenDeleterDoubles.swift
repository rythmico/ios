import FoundationEncore

final class DeviceTokenDeleterSpy: DeviceTokenDeleter {
    var unregisterCount = 0

    func deleteToken(completion: @escaping ErrorHandler) {
        unregisterCount += 1
    }
}

final class DeviceTokenDeleterDummy: DeviceTokenDeleter {
    func deleteToken(completion: @escaping ErrorHandler) {
        // NO-OP
    }
}
