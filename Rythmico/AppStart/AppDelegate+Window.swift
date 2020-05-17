import SwiftUI
import Then
import BetterSheet

extension AppDelegate {
    func configureWindow() {
        window = Window().then {
            $0.traitCollectionDidChange = { _ in self.configureGlobalAppearance() }
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
