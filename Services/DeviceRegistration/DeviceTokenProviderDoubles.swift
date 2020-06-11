import Foundation
import FirebaseInstanceID

final class DeviceTokenProviderDummy: DeviceTokenProvider {
    func instanceID(handler: @escaping InstanceIDResultHandler) {}
}
