import FirebaseInstanceID

final class DeviceTokenDeleterSpy: DeviceTokenDeleter {
    var unregisterCount = 0

    func deleteID(handler: @escaping InstanceIDDeleteHandler) {
        unregisterCount += 1
    }
}

final class DeviceTokenDeleterDummy: DeviceTokenDeleter {
    func deleteID(handler: @escaping InstanceIDDeleteHandler) {
        // NO-OP
    }
}
