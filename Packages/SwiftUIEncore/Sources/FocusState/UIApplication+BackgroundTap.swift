public protocol BackgroundTapActionCoordinator {
    func onBackgroundTap(perform action: @escaping () -> Void)
}

extension UIApplication: BackgroundTapActionCoordinator {
    public func onBackgroundTap(perform action: @escaping () -> Void) {
        windows.first?.addGestureRecognizer(WindowTapGestureRecognizer(action: action))
    }
}

private final class WindowTapGestureRecognizer: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)

        addTarget(self, action: #selector(execute))
        requiresExclusiveTouchType = true
        cancelsTouchesInView = false
        delegate = self
    }

    @objc private func execute() {
        action()
    }
}
