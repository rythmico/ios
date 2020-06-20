import SwiftUI
import Then
import BetterSheet

extension AppDelegate {
    func configureWindow() {
        window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.rootViewController = UIHostingController.withBetterSheetSupport(rootView: RootView())
            $0.makeKeyAndVisible()
        }
    }
}
