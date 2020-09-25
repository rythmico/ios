import UIKit

extension UINavigationController {
    open override func willMove(toParent parent: UIViewController?) {
        (parent as? UISplitViewController)?.do {
            $0.preferredSplitBehavior = .tile
            $0.preferredDisplayMode = .oneBesideSecondary
            $0.preferredPrimaryColumnWidthFraction = 0.27
            $0.minimumPrimaryColumnWidth = .spacingUnit * 90
            $0.maximumPrimaryColumnWidth = .spacingMax
        }

        super.willMove(toParent: parent)
    }
}
