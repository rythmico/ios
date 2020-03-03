import UIKit
import Firebase
import class SwiftUI.UIHostingController
import Then
import BetterSheet

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: Window?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configureGlobalStyles()
        configureWindow()
        return true
    }

    // Hopefully to be deleted someday if SwiftUI allows for better customization.
    private func configureGlobalStyles() {
        UINavigationBar.appearance().do {
            $0.isTranslucent = false
            $0.barTintColor = .systemBackground
            $0.backgroundColor = .systemBackground
            $0.largeTitleTextAttributes = [
                .foregroundColor: UIColor.rythmicoForeground,
                .font: UIFont.rythmicoFont(.largeTitle)
            ]
            $0.titleTextAttributes = [
                .foregroundColor: UIColor.rythmicoForeground,
                .font: UIFont.rythmicoFont(.subheadline)
            ]
            $0.layoutMargins.left = .spacingMedium
            $0.layoutMargins.right = .spacingMedium
        }

        UITableView.appearance().do {
            $0.backgroundColor = .clear
        }

        UITabBarItem.appearance().do {
            $0.setTitleTextAttributes([.font: UIFont.rythmicoFont(.caption)], for: .normal)
        }

        UITabBar.appearance().do {
            $0.unselectedItemTintColor = .rythmicoGray90
        }

        UISwitch.appearance().do {
            $0.onTintColor = .rythmicoPurple
        }
    }

    private func configureWindow() {
        window = Window().then {
            $0.traitCollectionDidChange = { _ in self.configureGlobalStyles() }
            $0.rootViewController = UIHostingController.withBetterSheetSupport(rootView: rootView)
            $0.makeKeyAndVisible()
        }
    }

    private var rootView: RootView {
        RootView(
            keychain: Keychain.localKeychain,
            onboardingViewModel: OnboardingViewModel(
                appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
                authenticationService: AuthenticationService(),
                keychain: Keychain.localKeychain
            ),
            authorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
            authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserver(
                notificationCenter: NotificationCenter.default
            ),
            authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserver(
                broadcast: AuthenticationAccessTokenProviderBroadcast()
            ),
            deauthenticationService: DeauthenticationService()
        )
    }
}
