import UIKit

private extension AppContext {
    var delegateType: UIApplicationDelegate.Type {
        switch self {
        case .test, .preview:
            return AppDelegateDummy.self
        case .debug, .release:
            return AppDelegate.self
        }
    }
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppContext.current.delegateType))
