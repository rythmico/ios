import Foundation

extension String: Identifiable {
    public var id: String { self }
}

extension String {
    public static var whitespace: String { " " }
    public static var newline: String { "\n" }
    public static var empty: String { "" }
}

extension String {
    public func repeated(_ count: Int = 2) -> String {
        String(repeating: self, count: count)
    }
}

extension String {
    public var firstWord: String? {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .lazy
            .split(separator: .whitespace)
            .first
            .map(String.init)
    }
}
