import SwiftUI
import Introspect

extension View {
    func sheetInteractiveDismissal(_ enabled: Bool, onAttempt: (() -> Void)? = nil) -> some View {
        introspectViewController {
            guard let presentationController = $0.ultimateParent.presentationController else {
                return
            }
            let delegate = AdaptivePresentationControllerDelegate(shouldDismiss: enabled, didAttemptToDismiss: onAttempt)
            controllerDelegateMap.setObject(delegate, forKey: presentationController)
            presentationController.delegate = delegate
        }
    }
}

private extension UIViewController {
    var ultimateParent: UIViewController { parent?.ultimateParent ?? self }
}

private final class AdaptivePresentationControllerDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    let shouldDismiss: Bool
    let didAttemptToDismiss: (() -> Void)?

    init(shouldDismiss: Bool, didAttemptToDismiss: (() -> Void)?) {
        self.shouldDismiss = shouldDismiss
        self.didAttemptToDismiss = didAttemptToDismiss
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        shouldDismiss
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        didAttemptToDismiss?()
    }
}

private var controllerDelegateMap = NSMapTable<UIPresentationController, AdaptivePresentationControllerDelegate>(keyOptions: .weakMemory, valueOptions: .strongMemory)
