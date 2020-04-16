import UIKit

protocol Screen {
    var bounds: CGRect { get }
}

extension UIScreen: Screen {}

extension UIScreen {
    @available(iOS 13, *)
    var isLarge: Bool {
        bounds.height >= 667
    }
}
