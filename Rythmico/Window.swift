import UIKit
import Sugar

final class Window: UIWindow {
    var traitCollectionDidChange: Handler<(old: UITraitCollection?, new: UITraitCollection)>?

    init() {
        super.init(frame: UIScreen.main.bounds)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are dodo")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        traitCollectionDidChange?((old: previousTraitCollection, new: traitCollection))
    }
}
