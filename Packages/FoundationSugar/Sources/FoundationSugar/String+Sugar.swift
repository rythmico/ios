extension String {
    public static var empty: String { "" }
    public static var whitespace: String { " " }
    public static var dash: String { "-" }
    public static var newline: String { "\n" }
    public static var period: String { "." }
    public static var comma: String { "," }
    public static var quote: String { "\"" }
    public static var openQuote: String { "“" }
    public static var closeQuote: String { "”" }
    public static var colon: String { ":" }
    public static var openParenthesis: String { "(" }
    public static var closeParenthesis: String { ")" }
}

extension StringProtocol {
    public var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var nilIfBlank: Self? {
        isBlank ? nil : self
    }

    public func quoted() -> String {
        .quote + String(self) + .quote
    }

    public func smartQuoted() -> String {
        .openQuote + String(self) + .closeQuote
    }

    public func parenthesized() -> String {
        .openParenthesis + String(self) + .closeParenthesis
    }

    public func repeated(_ count: Int = 2) -> String {
        String(repeating: String(self), count: count)
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

extension StringProtocol {
    public func word(at index: Int) -> String? {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .lazy
            .split(separator: .whitespace)
            .dropFirst(index)
            .first
            .map(String.init)
    }

    public var firstWord: String? {
        word(at: 0)
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

    public func spacedAndDashed() -> String {
        joined(separator: .whitespace + .dash + .whitespace)
    }
}
