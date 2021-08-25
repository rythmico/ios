import SwiftUIEncore

extension UINavigationController {
    open override func willMove(toParent parent: UIViewController?) {
        parent as? UISplitViewController ?=> {
            $0.preferredSplitBehavior = .tile
            $0.preferredDisplayMode = .oneBesideSecondary
            $0.preferredPrimaryColumnWidthFraction = 0.27
            $0.minimumPrimaryColumnWidth = .grid(90)
            $0.maximumPrimaryColumnWidth = .grid(.max)
        }

        super.willMove(toParent: parent)
    }
}
