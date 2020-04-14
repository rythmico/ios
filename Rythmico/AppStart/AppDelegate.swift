import SwiftUI
import Firebase
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

    // TODO: hopefully to be deleted someday if SwiftUI allows for better customization.
    private func configureGlobalStyles() {
        UINavigationBar.appearance().do { bar in
            UINavigationBarAppearance().do {
                $0.configureWithOpaqueBackground()
                $0.largeTitleTextAttributes = [
                    .foregroundColor: UIColor.rythmicoForeground,
                    .font: UIFont.rythmicoFont(.largeTitle)
                ]
                $0.titleTextAttributes = [
                    .foregroundColor: UIColor.rythmicoForeground,
                    .font: UIFont.rythmicoFont(.subheadline)
                ]
                $0.shadowColor = nil
                bar.standardAppearance = $0
                bar.compactAppearance = $0
                bar.scrollEdgeAppearance = $0

                bar.isTranslucent = false

                bar.layoutMargins.left = .spacingMedium
                bar.layoutMargins.right = .spacingMedium
            }
        }

        UITableView.appearance().do {
            $0.backgroundColor = .clear
        }

        UITabBar.appearance().do { bar in
            UITabBarAppearance().do {
                [
                    $0.compactInlineLayoutAppearance,
                    $0.inlineLayoutAppearance,
                    $0.stackedLayoutAppearance
                ].forEach {
                    $0.normal.iconColor = .rythmicoGray90
                    $0.normal.titleTextAttributes = [
                        .font: UIFont.rythmicoFont(.caption),
                        .foregroundColor: UIColor.rythmicoGray90
                    ]
                }
                bar.standardAppearance = $0
            }
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

    private var rootView: some View {
        RootView(
            keychain: Keychain.localKeychain,
            appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
            authenticationService: AuthenticationService(),
            authorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
            authorizationCredentialRevocationNotifying: AppleAuthorizationCredentialRevocationNotifier(
                notificationCenter: NotificationCenter.default
            ),
            authenticationAccessTokenProviderObserving: AuthenticationAccessTokenProviderObserver(
                broadcast: AuthenticationAccessTokenProviderBroadcast()
            ),
            deauthenticationService: DeauthenticationService()
        )
    }
}
