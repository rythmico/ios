import FoundationSugar
import FirebaseMessaging

protocol DeviceTokenDeleter {
    typealias ErrorHandler = Handler<Error?>
    func deleteToken(completion: @escaping ErrorHandler)
}

extension Messaging: DeviceTokenDeleter {}
