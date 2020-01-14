#if DEBUG
import SwiftUI

class TestingSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(
            rootView: ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                Text("Running Unit Tests...").foregroundColor(.white)
            }
            .environment(\.colorScheme, .light)
        )
        window?.makeKeyAndVisible()
    }
}
#endif
