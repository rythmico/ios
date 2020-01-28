import UIKit
import class Firebase.FirebaseApp
import class SwiftUI.UIHostingController

final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let rootView = RootView(
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

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: rootView)
        window?.makeKeyAndVisible()

        return true
    }
}
