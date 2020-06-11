import SwiftUI
import Then
import BetterSheet

extension AppDelegate {
    func configureWindow() {
        window = Window().then {
            $0.traitCollectionDidChange = { _ in self.configureGlobalAppearance() }
            $0.rootViewController = UIHostingController.withBetterSheetSupport(rootView: RootView())
            $0.makeKeyAndVisible()
        }
    }
}
