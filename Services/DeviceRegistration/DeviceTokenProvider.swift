import Foundation
import FirebaseMessaging

protocol DeviceTokenProvider {
    typealias ResultHandler = (String?, Error?) -> Void
    func deviceToken(handler: @escaping ResultHandler)
}

extension Messaging: DeviceTokenProvider {
    func deviceToken(handler: @escaping ResultHandler) {
        token(completion: handler)
    }
}
