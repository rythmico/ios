import SwiftUI

final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootView = RootView(
            viewModel: RootViewModel(
                onboardingViewModel: OnboardingViewModel(
                    appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
                    authenticationService: AuthenticationService(),
                    dispatchQueue: .main
                ),
                authenticationStatusBroadcast: AuthenticationStatusBroadcast()
            )
        )

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: rootView)
        window?.makeKeyAndVisible()

        return true
    }
}
