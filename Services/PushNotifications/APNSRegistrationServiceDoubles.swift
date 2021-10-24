import FoundationEncore

final class APNSRegistrationServiceSpy: APNSRegistrationServiceProtocol {
    var registerCount = 0
    var unregisterCount = 0

    func registerForRemoteNotifications() {
        registerCount += 1
    }

    func unregisterForRemoteNotifications() {
        unregisterCount += 1
    }
}

final class APNSRegistrationServiceDummy: APNSRegistrationServiceProtocol {
    func registerForRemoteNotifications() {}
    func unregisterForRemoteNotifications() {}
}
