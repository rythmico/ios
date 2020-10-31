import Foundation

@main
struct AppLauncher {
    static func main() {
        if isRunningFullApp {
            App.main()
        } else {
            AppFake.main()
        }
    }

    static var isRunningFullApp: Bool {
        switch AppContext.current {
        case .test, .preview:
            return false
        case .run, .release:
            return true
        }
    }
}
