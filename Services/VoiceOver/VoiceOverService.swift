import UIKit

protocol VoiceOverServiceProtocol {
    static func announce(_ content: String)
}

extension UIAccessibility: VoiceOverServiceProtocol {
    static func announce(_ content: String) {
        post(notification: .announcement, argument: NSString(string: content))
    }
}
