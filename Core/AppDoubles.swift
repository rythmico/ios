import SwiftUI

struct AppFake: SwiftUI.App {
    init() {
        App.configureAppearance(for: UIWindow())
    }

    var body: some Scene {
        WindowGroup {}
    }
}
