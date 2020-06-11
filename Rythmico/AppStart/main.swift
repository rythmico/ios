import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
let isRunningPreviews = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(isRunningTests ? TestDelegate.self : AppDelegate.self)
)
