import UIKit

protocol UIAccessibilityProtocol {
    static func postAnnouncement(_ content: String)
}

extension UIAccessibility: UIAccessibilityProtocol {
    static func postAnnouncement(_ content: String) {
        post(notification: .announcement, argument: NSString(string: content))
    }
}
