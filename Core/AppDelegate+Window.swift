import SwiftUI
import Then
import Sugar

extension AppDelegate {
    func configureWindow() {
        window = Window().then {
            $0.traitCollectionDidChange = { _ in App.refresh() }
            $0.rootViewController = UIHostingController(rootView: RootView())
            $0.makeKeyAndVisible()
        }
    }
}

private final class Window: UIWindow {
    var traitCollectionDidChange: Handler<(old: UITraitCollection?, new: UITraitCollection)>?

    init() {
        super.init(frame: UIScreen.main.bounds)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are doodoo")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollectionDidChange?((old: previousTraitCollection, new: traitCollection))
    }
}
