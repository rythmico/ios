import SwiftUI
import Sugar

protocol BackgroundTapActionCoordinator {
    func onBackgroundTap(perform action: @escaping Action)
}

extension UIApplication: BackgroundTapActionCoordinator {
    func onBackgroundTap(perform action: @escaping Action) {
        windows.first?.addGestureRecognizer(WindowTapGestureRecognizer(action: action))
    }
}

private final class WindowTapGestureRecognizer: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    private var action: Action

    init(action: @escaping Action) {
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
