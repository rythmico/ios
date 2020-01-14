import UIKit

#if DEBUG
let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass = NSStringFromClass(isRunningTests ? TestingAppDelegate.self : AppDelegate.self)
#else
let appDelegateClass = NSStringFromClass(AppDelegate.self)
#endif

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)
