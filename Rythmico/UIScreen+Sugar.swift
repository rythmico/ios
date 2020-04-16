import UIKit

extension UIScreen {
    @available(iOS 13, *)
    var isLarge: Bool {
        bounds.height >= 667
    }
}
