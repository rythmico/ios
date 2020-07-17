import UIKit

enum AppContext {
    case test
    case preview
    case debug
    case release

    static var current: Self {
        #if DEBUG
        if NSClassFromString("XCTestCase") != nil { return .test }
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return .preview }
        return .debug
        #else
        return .release
        #endif
    }
}
