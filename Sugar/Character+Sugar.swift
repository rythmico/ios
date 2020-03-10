import Foundation

extension Character {
    public static var whitespace: Character { " " }
    public static var newline: Character { "\n" }
}

extension Character {
    public func repeated(_ count: Int = 2) -> String {
        String(repeating: self, count: count)
    }
}
