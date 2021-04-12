import SwiftUI

// TODO: remove in Swift 5.5
// https://github.com/apple/swift-evolution/blob/main/proposals/0299-extend-generic-static-member-lookup.md

@available(swift, obsoleted: 5.5)
extension Text {
    static var whitespace: Text { Text(String.whitespace) }
    static var newline: Text { Text(String.newline) }
}
