extension View {
    public func navigationViewFixInteractiveDismissal() -> some View {
        introspectNavigationController { navigationController in
            guard let gestureRecognizer = navigationController.interactivePopGestureRecognizer else {
                return
            }
            let handler = InteractivePopGestureHandler()
            recognizerHandlerMap.setObject(handler, forKey: gestureRecognizer)
            gestureRecognizer.addTarget(handler, action: #selector(InteractivePopGestureHandler.handle))
        }
    }
}

private final class InteractivePopGestureHandler: NSObject {
    @objc func handle(_ gestureRecognizer: UIGestureRecognizer) {
        guard
            case .ended = gestureRecognizer.state,
            let view = gestureRecognizer.view
        else {
            return
        }

        let tag = 420

        view.navigationBarButtons.forEach { $0.tag = tag }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak view] in
            guard let view = view else { return }

            let navigationBarButtons = view.navigationBarButtons
            let newButtons = navigationBarButtons.filter { $0.tag != tag }
            let oldButtons = navigationBarButtons.filter { $0.tag == tag }

            for newButton in newButtons {
                oldButtons.filter { $0.frame == newButton.frame }.forEach { $0.removeFromSuperview() }
            }

            newButtons.forEach { $0.tag = 0 }
        }
    }
}

private extension UIView {
    var navigationBarButtons: [UIView] {
        guard
            let navigationBar = subviews.first(where: { $0 is UINavigationBar }),
            let navigationBarContent = navigationBar.subviews.first(where: { NSStringFromClass(type(of: $0)) == "_UINavigationBarContentView" })
        else {
            return []
        }
        return navigationBarContent.subviews.filter({ NSStringFromClass(type(of: $0)) == "_UIButtonBarButton" })
    }
}

private var recognizerHandlerMap = NSMapTable<UIGestureRecognizer, InteractivePopGestureHandler>(keyOptions: .weakMemory, valueOptions: .strongMemory)
