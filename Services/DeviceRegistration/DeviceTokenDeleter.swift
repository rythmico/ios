import Foundation
import FirebaseMessaging
import Sugar

protocol DeviceTokenDeleter {
    typealias ErrorHandler = Handler<Error?>
    func deleteToken(completion: @escaping ErrorHandler)
}

extension Messaging: DeviceTokenDeleter {}
