import Foundation

enum AppContext {
    case test
    case preview
    case run
    case release

    static var current: Self {
        #if DEBUG
        if NSClassFromString("XCTestCase") != nil { return .test }
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return .preview }
        return .run
        #else
        return .release
        #endif
    }
}
