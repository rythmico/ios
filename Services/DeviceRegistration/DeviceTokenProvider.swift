import Foundation
import FirebaseInstanceID

protocol DeviceTokenProtocol {
    var instanceID: String { get }
    var token: String { get }
}

extension InstanceIDResult: DeviceTokenProtocol {}

protocol DeviceTokenProvider {
    typealias ResultHandler = (DeviceTokenProtocol?, Error?) -> Void
    func deviceToken(handler: @escaping ResultHandler)
}

extension InstanceID: DeviceTokenProvider {
    func deviceToken(handler: @escaping ResultHandler) {
        instanceID { handler($0, $1) }
    }
}
