import UIKit

protocol APNSRegistrationServiceProtocol {
    func registerForRemoteNotifications()
    func unregisterForRemoteNotifications()
}

extension UIApplication: APNSRegistrationServiceProtocol {}
