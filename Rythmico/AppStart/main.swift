import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(isRunningTests ? TestDelegate.self : AppDelegate.self)
)
