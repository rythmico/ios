import SwiftUI
import Introspect

extension View {
    func navigationBarBackButtonItem<B: View>(_ button: B) -> some View {
        self.navigationBarBackButtonHiddenMaintainingInteractivePopGesture(true)
            .navigationBarItems(leading: button)
    }

    func navigationBarBackButtonHiddenMaintainingInteractivePopGesture(_ hidden: Bool) -> some View {
        self.navigationBarBackButtonHidden(hidden)
            .navigationLinkInteractiveDismissal(true)
    }

    func navigationLinkInteractiveDismissal(_ enabled: Bool) -> some View {
        introspectNavigationController { navigationController in
            let delegate = InteractivePopGestureDelegate(shouldDismiss: enabled)
            controllerDelegateMap.setObject(delegate, forKey: navigationController)
            navigationController.interactivePopGestureRecognizer?.delegate = delegate
        }
    }
}

private final class InteractivePopGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    let shouldDismiss: Bool

    init(shouldDismiss: Bool) {
        self.shouldDismiss = shouldDismiss
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldDismiss
    }
}

private var controllerDelegateMap = NSMapTable<UINavigationController, InteractivePopGestureDelegate>(keyOptions: .weakMemory, valueOptions: .strongMemory)
