#if DEBUG
import UIKit

struct UIAccessibilityDummy: UIAccessibilityProtocol {
    static func postAnnouncement(_ content: String) {}
}
#endif
