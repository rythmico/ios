import Foundation
import FirebaseInstanceID

protocol DeviceTokenDeleter {
    func deleteID(handler: @escaping InstanceIDDeleteHandler)
}

extension InstanceID: DeviceTokenDeleter {}
