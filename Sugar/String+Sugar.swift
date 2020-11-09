import Foundation

extension String: Identifiable {
    public var id: String { self }
}

extension String {
    public static var empty: String { "" }
    public static var whitespace: String { " " }
    public static var newline: String { "\n" }
    public static var comma: String { "," }
    public static var quote: String { "\"" }
}

extension String {
    public var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public func quoted() -> String {
        .quote + self + .quote
    }

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

    public func trimmingLineCharacters(in set: CharacterSet) -> String {
        self.split(separator: .newline)
            .map { $0.trimmingCharacters(in: set) }
            .joined(separator: .newline)
    }

    public func replacingCharacters(in set: CharacterSet, with replacement: String) -> String {
        components(separatedBy: set).joined(separator: replacement)
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

    public var initials: String {
        self.split(separator: .whitespace)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .compactMap { $0.first?.uppercased() }
            .joined()
    }
}

extension Collection where Element: StringProtocol {
    public func spaced() -> String {
        joined(separator: .whitespace)
    }
}
