import SwiftUI
import Introspect

extension View {
    func sheetInteractiveDismissal(_ enabled: Bool) -> some View {
        introspectViewController {
            $0.ultimateParent.isModalInPresentation = !enabled
        }
    }
}

private extension UIViewController {
    var ultimateParent: UIViewController { parent?.ultimateParent ?? self }
}
