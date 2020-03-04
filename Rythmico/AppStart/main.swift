import UIKit

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(
        NSClassFromString("XCTestCase") == nil ? AppDelegate.self : TestDelegate.self
    )
)
