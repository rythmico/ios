import UIKit

// TODO: remove when targeting iOS 15 only.
extension UINavigationBar {
    var compactScrollEdgeAppearance_iOS15: UINavigationBarAppearance? {
        get {
            if #available(iOS 15, *) {
                return compactScrollEdgeAppearance
            } else {
                return nil
            }
        }
        set {
            if #available(iOS 15, *) {
                compactScrollEdgeAppearance = newValue
            } else {
                // NOOP
            }
        }
    }
}

// TODO: remove when targeting iOS 15 only.
extension UITabBar {
    var scrollEdgeAppearance_iOS15: UITabBarAppearance? {
        get {
            if #available(iOS 15, *) {
                return scrollEdgeAppearance
            } else {
                return nil
            }
        }
        set {
            if #available(iOS 15, *) {
                scrollEdgeAppearance = newValue
            } else {
                // NOOP
            }
        }
    }
}
