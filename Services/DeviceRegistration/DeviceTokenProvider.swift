import Foundation
import FirebaseInstanceID

protocol DeviceTokenProvider {
    func instanceID(handler: @escaping InstanceIDResultHandler)
}

extension InstanceID: DeviceTokenProvider {}
