import UIKit
import class Firebase.FirebaseApp
import class SwiftUI.UIHostingController
import Auth
import Then

final class AppDelegate: UIResponder, UIApplicationDelegate {
    private enum Const {
        static let defaultNavigationBarLargeTitleLeadingInset: CGFloat = 20
    }

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
            $0.largeTitleTextAttributes = [.font: UIFont.rythmicoFont(.largeTitle)]
            $0.titleTextAttributes = [.font: UIFont.rythmicoFont(.headline)]
            $0.layoutMargins.left = Const.defaultNavigationBarLargeTitleLeadingInset
            $0.layoutMargins.right = Const.defaultNavigationBarLargeTitleLeadingInset
        }

        UITableView.appearance().do {
            $0.backgroundColor = .clear
        }

        UITabBarItem.appearance().do {
            $0.setTitleTextAttributes([.font: UIFont.rythmicoFont(.caption)], for: .normal)
        }
    }

    private func configureWindow() {
        window = Window().then {
            $0.traitCollectionDidChange = { _ in self.configureGlobalStyles() }
            $0.rootViewController = UIHostingController(rootView: rootView)
            $0.makeKeyAndVisible()
        }
    }

    private var rootView: RootView {
        RootView(
            viewModel: RootViewModel(
                keychain: Keychain.localKeychain,
                onboardingViewModel: OnboardingViewModel(
                    appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
                    authenticationService: AuthenticationService(),
                    keychain: Keychain.localKeychain,
                    dispatchQueue: .main
                ),
                authorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
                authorizationCredentialRevocationObserving: AppleAuthorizationCredentialRevocationObserver(
                    notificationCenter: NotificationCenter.default
                ),
                authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserver(
                    broadcast: AuthenticationAccessTokenProviderBroadcast()
                ),
                deauthenticationService: DeauthenticationService(),
                dispatchQueue: .main
            )
        )
    }
}
