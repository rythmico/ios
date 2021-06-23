import FoundationSugar
import FirebaseMessaging
import FoundationSugar

protocol DeviceTokenDeleter {
    typealias ErrorHandler = Handler<Error?>
    func deleteToken(completion: @escaping ErrorHandler)
}

extension Messaging: DeviceTokenDeleter {}
