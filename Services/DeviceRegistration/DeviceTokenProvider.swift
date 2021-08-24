import FoundationEncore
import FirebaseMessaging

protocol DeviceTokenProvider {
    typealias _ResultHandler = (String?, Error?) -> Void
    func deviceToken(handler: @escaping _ResultHandler)
}

extension Messaging: DeviceTokenProvider {
    func deviceToken(handler: @escaping _ResultHandler) {
        token(completion: handler)
    }
}
