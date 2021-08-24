import FoundationEncore

@main
struct AppLauncher {
    static func main() {
        #if DEBUG
        if isRunningFullApp {
            App.main()
        } else {
            AppFake.main()
        }
        #else
        App.main()
        #endif
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
