import Foundation

extension String: Identifiable {
    public var id: String { self }
}

extension String {
    public static var empty: String { "" }
    public static var whitespace: String { " " }
    public static var newline: String { "\n" }
    public static var comma: String { "," }
}

extension String {
    public func repeated(_ count: Int = 2) -> String {
        String(repeating: self, count: count)
    }

    public func repeating(_ character: Character, count: Int) -> String {
        self.split(separator: character)
            .filter(\.isEmpty.not)
            .joined(separator: character.repeated(count))
    }

    public func removingRepetitionOf(_ character: Character) -> String {
        repeating(character, count: 1)
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
